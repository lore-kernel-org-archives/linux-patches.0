Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078F941232;
	Mon,  1 Apr 2024 16:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990325; cv=none; b=V1JFAn+PkEj35wIqZSt2T/C7XAwJquH3cVxjF8QzKRXJ7GsRM/2doHnb6+3tDq8ncEV54oC0hx0ch/8I1rzPwCTl9lOoVeDNUgU2EGLO64p/JlV0HiJ4pIidQvKhYFiSfcyZJvlUWS+E0pA5TwDgfLbeTNDGBP0uOq2NQosQLhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990325; c=relaxed/simple;
	bh=79ucNpWDOWo+tkq2wX+3OeNoXI6ySD9mOaXBFlQANH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kENLnkm6xrC6/Nffafe2cxwYkFrXpf4f5rQZgREn6RtZsyRieE/TMSGRWyocuII/h1z4VJaV+p4MaK5UqAFDrHNWKbxgdZ0zi53B0wgkzY2hgp9h2WlnlrSHMvAW3+63ZHBA/CwIcOPGOzjJYbc+R+jGDYhmsS9CTAb/ihZqhiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SLdnj47I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SLdnj47I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D9D5C433F1;
	Mon,  1 Apr 2024 16:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990324;
	bh=79ucNpWDOWo+tkq2wX+3OeNoXI6ySD9mOaXBFlQANH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SLdnj47ILwY3h7hoEsxjq5/D1bTQ5nYeldoDv8S+3UEn8HJ+NhidZE2Ms8mNspAIV
	 xnRuaN5JdmHwtAUYErMU/1pxrCrVAIY9sw1iE9JWe9b23EiywB9YzbLCNSFHbi8viM
	 Osu96ArzdYAXPYfrZpWn4dt5r5dSpQpjAJUGMMTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Christoph Hellwig <hch@lst.de>,
	Tavian Barnes <tavianator@tavianator.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 317/396] btrfs: fix race in read_extent_buffer_pages()
Date: Mon,  1 Apr 2024 17:46:06 +0200
Message-ID: <20240401152557.363167202@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tavian Barnes <tavianator@tavianator.com>

commit ef1e68236b9153c27cb7cf29ead0c532870d4215 upstream.

There are reports from tree-checker that detects corrupted nodes,
without any obvious pattern so possibly an overwrite in memory.
After some debugging it turns out there's a race when reading an extent
buffer the uptodate status can be missed.

To prevent concurrent reads for the same extent buffer,
read_extent_buffer_pages() performs these checks:

    /* (1) */
    if (test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags))
        return 0;

    /* (2) */
    if (test_and_set_bit(EXTENT_BUFFER_READING, &eb->bflags))
        goto done;

At this point, it seems safe to start the actual read operation. Once
that completes, end_bbio_meta_read() does

    /* (3) */
    set_extent_buffer_uptodate(eb);

    /* (4) */
    clear_bit(EXTENT_BUFFER_READING, &eb->bflags);

Normally, this is enough to ensure only one read happens, and all other
callers wait for it to finish before returning.  Unfortunately, there is
a racey interleaving:

    Thread A | Thread B | Thread C
    ---------+----------+---------
       (1)   |          |
             |    (1)   |
       (2)   |          |
       (3)   |          |
       (4)   |          |
             |    (2)   |
             |          |    (1)

When this happens, thread B kicks of an unnecessary read. Worse, thread
C will see UPTODATE set and return immediately, while the read from
thread B is still in progress.  This race could result in tree-checker
errors like this as the extent buffer is concurrently modified:

    BTRFS critical (device dm-0): corrupted node, root=256
    block=8550954455682405139 owner mismatch, have 11858205567642294356
    expect [256, 18446744073709551360]

Fix it by testing UPTODATE again after setting the READING bit, and if
it's been set, skip the unnecessary read.

Fixes: d7172f52e993 ("btrfs: use per-buffer locking for extent_buffer reading")
Link: https://lore.kernel.org/linux-btrfs/CAHk-=whNdMaN9ntZ47XRKP6DBes2E5w7fi-0U3H2+PS18p+Pzw@mail.gmail.com/
Link: https://lore.kernel.org/linux-btrfs/f51a6d5d7432455a6a858d51b49ecac183e0bbc9.1706312914.git.wqu@suse.com/
Link: https://lore.kernel.org/linux-btrfs/c7241ea4-fcc6-48d2-98c8-b5ea790d6c89@gmx.com/
CC: stable@vger.kernel.org # 6.5+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Tavian Barnes <tavianator@tavianator.com>
Reviewed-by: David Sterba <dsterba@suse.com>
[ minor update of changelog ]
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4047,6 +4047,19 @@ int read_extent_buffer_pages(struct exte
 	if (test_and_set_bit(EXTENT_BUFFER_READING, &eb->bflags))
 		goto done;
 
+	/*
+	 * Between the initial test_bit(EXTENT_BUFFER_UPTODATE) and the above
+	 * test_and_set_bit(EXTENT_BUFFER_READING), someone else could have
+	 * started and finished reading the same eb.  In this case, UPTODATE
+	 * will now be set, and we shouldn't read it in again.
+	 */
+	if (unlikely(test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags))) {
+		clear_bit(EXTENT_BUFFER_READING, &eb->bflags);
+		smp_mb__after_atomic();
+		wake_up_bit(&eb->bflags, EXTENT_BUFFER_READING);
+		return 0;
+	}
+
 	clear_bit(EXTENT_BUFFER_READ_ERR, &eb->bflags);
 	eb->read_mirror = 0;
 	check_buffer_tree_ref(eb);


