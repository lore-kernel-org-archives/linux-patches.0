Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57AD3FBB42;
	Fri, 15 May 2026 16:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861247; cv=none; b=fdBVCKoqW8JVueuWh/lcdtxWzzLvHss9Cim9RkDLScbwJILg0C035yUr5avu7FwAZzSC758Bid+bK6fK1zMFf/1lOGCUHT4Bp/2GuSh/kEnXSBCvYN7WA4/xylv9CjGcnf3rIs0OcqrYEVf9TArhPh/9IaE9Nejt6iNPDTgs998=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861247; c=relaxed/simple;
	bh=3ekHlA+mYjEkse6KcpWoT4DqKHAZCoJqNgK6irlCYsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lgQZzRYuMofozI7vb4ExzZcQA6xj1PG7Y0vnx/RZ11hmGvpEPVqf9CPVjNTc4efq3wgYYQLyq3SPfUjqyTto/WVw2ngPp7Fp7AhwK31MOMobF9gqcX34ujJjWj5XKO7dz4LR7iCj/17kQZWVzREnUdw95g7hQ8fC71/eUEm2+CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AprLD/jl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AprLD/jl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C9BC2BCB0;
	Fri, 15 May 2026 16:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861247;
	bh=3ekHlA+mYjEkse6KcpWoT4DqKHAZCoJqNgK6irlCYsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AprLD/jlvJz6usR6fO71fPUgupfmruxWbbYyWwRc8A0K2lLlsglGQTVXBYDv45omB
	 rxEKWFzhOsq3VKmQk9kUkpVO7R1UtDq9Do/V/6N4FhJec64LZh86xe5P+fS37yqIvl
	 McGNgp1XZa9p041kIgmNuCQqDdy5Kz+Jw2DVip5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.6 256/474] dm-verity-fec: correctly reject too-small hash devices
Date: Fri, 15 May 2026 17:46:05 +0200
Message-ID: <20260515154720.539002606@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 4355142245f7e55336dcc005ec03592df4d546f8 upstream.

Fix verity_fec_ctr() to reject too-small hash devices by correctly
taking hash_start into account.

Note that this is necessary because dm-verity doesn't call
dm_bufio_set_sector_offset() on the hash device's bufio client
(v->bufio).  Thus, dm_bufio_get_device_size(v->bufio) returns a size
relative to 0 rather than hash_start.  An alternative fix would be to
call dm_bufio_set_sector_offset() on v->bufio, but then all the code
that reads from the hash device would have to be adjusted accordingly.

Fixes: a739ff3f543a ("dm verity: add support for forward error correction")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-fec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -751,7 +751,8 @@ int verity_fec_ctr(struct dm_verity *v)
 	 * it to be large enough.
 	 */
 	f->hash_blocks = f->blocks - v->data_blocks;
-	if (dm_bufio_get_device_size(v->bufio) < f->hash_blocks) {
+	if (dm_bufio_get_device_size(v->bufio) <
+	    v->hash_start + f->hash_blocks) {
 		ti->error = "Hash device is too small for "
 			DM_VERITY_OPT_FEC_BLOCKS;
 		return -E2BIG;


