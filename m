Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56391A3029;
	Tue, 21 Oct 2025 20:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077192; cv=none; b=kd849+unx1kaBbLInGug3+uqcO83ZSDo3X7T02OMgFqNGlzAcPYWF73+9Q0xCXIwvZQtpyV9qs24t5/VAXbIXbXHwyOKnpNTAlYaw8q1pEDuRYKDO0KAmzfjzc8t5DsS0rYH5Xs1SfjY6K7zbQp0oMZslYVCn42rbauvNkFyR98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077192; c=relaxed/simple;
	bh=jfHVLJlinWj9Q55MgfkNZBUALpHDbODKxbSllHb26mI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jg5nIBUzT4gpLXgoseFmb0YJ2jgufjONEDztu4JHqkGCtMLXMrPnB4hatxrlUpWgZAfNExuWbY4oNlPMuwnLd5qQej5JTJDg/HTWAhqBvkmTRYI0DjwIoi5ATQ5eWWKcmcJoY7H6pjRF0HKxacMfeEhPcMYNzASKLCSbmLjAk5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WAabRLDy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WAabRLDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31485C4CEF1;
	Tue, 21 Oct 2025 20:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077192;
	bh=jfHVLJlinWj9Q55MgfkNZBUALpHDbODKxbSllHb26mI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WAabRLDyCNKFt9LLFINEjyFxspi0T70yHfusY5NOYCt2ZlNICrw2p16pOzuRGbHEy
	 6kwFHjPMDZULnU0QDgLkcpTDLXIjduck2LDt7JInkHyomTzhZH+O9wNW3+HfL5Oujy
	 Wb0onsnqKPVSuED/Vx4hg5V8UmrzuiIktT3C6qhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Chernoff <git@maxchernoff.ca>,
	Filipe Manana <fdmanana@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.17 028/159] btrfs: fix incorrect readahead expansion length
Date: Tue, 21 Oct 2025 21:50:05 +0200
Message-ID: <20251021195043.870879988@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Burkov <boris@bur.io>

commit 8ab2fa69691b2913a67f3c54fbb991247b3755be upstream.

The intent of btrfs_readahead_expand() was to expand to the length of
the current compressed extent being read. However, "ram_bytes" is *not*
that, in the case where a single physical compressed extent is used for
multiple file extents.

Consider this case with a large compressed extent C and then later two
non-compressed extents N1 and N2 written over C, leaving C1 and C2
pointing to offset/len pairs of C:

[               C                 ]
[ N1 ][     C1     ][ N2 ][   C2  ]

In such a case, ram_bytes for both C1 and C2 is the full uncompressed
length of C. So starting readahead in C1 will expand the readahead past
the end of C1, past N2, and into C2. This will then expand readahead
again, to C2_start + ram_bytes, way past EOF. First of all, this is
totally undesirable, we don't want to read the whole file in arbitrary
chunks of the large underlying extent if it happens to exist. Secondly,
it results in zeroing the range past the end of C2 up to ram_bytes. This
is particularly unpleasant with fs-verity as it can zero and set
uptodate pages in the verity virtual space past EOF. This incorrect
readahead behavior can lead to verity verification errors, if we iterate
in a way that happens to do the wrong readahead.

Fix this by using em->len for readahead expansion, not em->ram_bytes,
resulting in the expected behavior of stopping readahead at the extent
boundary.

Reported-by: Max Chernoff <git@maxchernoff.ca>
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2399898
Fixes: 9e9ff875e417 ("btrfs: use readahead_expand() on compressed extents")
CC: stable@vger.kernel.org # 6.17
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -914,7 +914,7 @@ static void btrfs_readahead_expand(struc
 {
 	const u64 ra_pos = readahead_pos(ractl);
 	const u64 ra_end = ra_pos + readahead_length(ractl);
-	const u64 em_end = em->start + em->ram_bytes;
+	const u64 em_end = em->start + em->len;
 
 	/* No expansion for holes and inline extents. */
 	if (em->disk_bytenr > EXTENT_MAP_LAST_BYTE)


