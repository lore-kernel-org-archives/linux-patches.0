Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2329736EAB9;
	Tue, 17 Mar 2026 17:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768351; cv=none; b=VmXZkkmJv/2cTo/4iMHiVKUVqK3Hh3glnis6FpZCWmoZdGeMBDEOwoT6J6AHvmQC2mqlGWuClGU2QVqn8++4nKtoQcIJvjwjcvVOd1T+VY5feJDAkeI3MCFYMvNTvvQEtBim1kRm0UpvJ/n4K81wpyuF/kBHzdQY+KqIuWPv3aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768351; c=relaxed/simple;
	bh=L7AADAtLgR2aagaODFqUuJaDozWjH37i9JbMiZm8iN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZUOZA2Nm/VXal7in2CIlp8a+p/fZD3o9AJpJ0oT6HT5qw87QwpZIRkQYIAXX+XKymyFXde7+pFBgKwLV9y6y+cvgCI0QxxVhAUAtm/oIJmRqip/y4boQDxU4Yaw6Os9zPSfaFR3+/lgyUcBaBzXoUQh0ifr45qnetEOOGfTOZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GN6qi/tR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GN6qi/tR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA88C4CEF7;
	Tue, 17 Mar 2026 17:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768350;
	bh=L7AADAtLgR2aagaODFqUuJaDozWjH37i9JbMiZm8iN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GN6qi/tRmyQ1I1INaau3LA5oWCez208LEzNWrwG32sHgtJ9aGTFVhJcz8fOlyk4/o
	 H/+mMa5IBJNc8Vgn8GZyCUSGXmngbNaQHu3spMb/4AF1/kqlnrsm+siBpbNrlIwUgu
	 bdbJPpr0hFrfOqdOa4UieHd4D3khT+WegA06PscI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>,
	Bart Van Assche <bvanassche@acm.org>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.18 290/333] btrfs: add missing RCU unlock in error path in try_release_subpage_extent_buffer()
Date: Tue, 17 Mar 2026 17:35:19 +0100
Message-ID: <20260317163010.147501379@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit b2840e33127ce0eea880504b7f133e780f567a9b upstream.

Call rcu_read_lock() before exiting the loop in
try_release_subpage_extent_buffer() because there is a rcu_read_unlock()
call past the loop.

This has been detected by the Clang thread-safety analyzer.

Fixes: ad580dfa388f ("btrfs: fix subpage deadlock in try_release_subpage_extent_buffer()")
CC: stable@vger.kernel.org # 6.18+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4478,6 +4478,7 @@ static int try_release_subpage_extent_bu
 		 */
 		if (!test_and_clear_bit(EXTENT_BUFFER_TREE_REF, &eb->bflags)) {
 			spin_unlock(&eb->refs_lock);
+			rcu_read_lock();
 			break;
 		}
 


