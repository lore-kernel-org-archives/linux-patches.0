Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027609;
	b=J4ckMV/SF9Zf80U8BtgoetvKi3yHCiyWFtrFiFf64MC2libSNUYy+WuRZSd8OOfxpr59
	 SeQIIGtXLN3uN2TgQzbznmcunAx2arSiCSADuhUc1xgirwQqWAGWSfdbSZ14y+U5T8mqf
	 X6Uvouet/jkej1AujU9vy//ZBF6mUscM+QzULQKycnnhBoEPBtmc6JcQlcEk7yY9J8Gy9
	 LP4hNrRszMLvrOwXPjI/vCnH+iMSUWP/3iHxy2kOaU8HfmD7ZDSffmjOfo8ixsCZc6Cd1
	 pGTTRATUoPN1RmyINqSmXUziv6zY6b53fdG2HyQyioqS6spRuvgYzZ2uDX0GUg1YlZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027609;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ItGyPUEGqvi4NwiYltoUPGGPccYDv2to4qNBxh+fZXU=;
	b=aafS8NhmRwOh8Q/erzik+r61k57xNw9TyeyG/mzm/L+fxUoGQr11ed/8hTG8N3JVE/cc
	 b03d5+i0w96IcddmqX8lolV7u1hRdFJPgBCrZ2DKTfSn7LdjogG9elPORcdhbz8jhnUOC
	 lMl9CkEIL3l+N86mpAwcmYaebWqXIM9uZevspL3KW7N3uyzXwL06evov/3pIzse7d3Cq+
	 TmAzVe6j9QhuE6AucauMz7TP86ipP0RdHfaVjTZc9raTtARqiY4Ea/wJbkaL2zBHFKjEP
	 D2WeZu39qZOHkeCVnIhFebHjMAbwAK+RjaIEL+y78tYqhw1Ig47JkGjIL6v2cOn+qGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RR8zVunJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A069D606A31C;
	Wed, 18 Nov 2026 18:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RR8zVunJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0157C1F000C4;
	Wed, 18 Nov 2026 18:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027609;
	bh=ItGyPUEGqvi4NwiYltoUPGGPccYDv2to4qNBxh+fZXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RR8zVunJpNt3dGY10hLGhH2uVPGH+2tvkQFmXgrEkGhjaVni76iGIen9p1wvknguw
	 4a7F4sef6KP//jv2X+SZxtSSKPs5N/Dwu4wma1eXjNoKTIYzTsthULbbvR1ufGPDJx
	 tomDaKZtMtUlQ9JIw/Cc4vuf7G/5l849EsPY2mfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1850/2151] ksmbd: stabilize allocation size after buffered writes
Date: Wed, 18 Nov 2026 15:59:45 +0100
Message-ID: <20261118150229.188863190@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 84c41b731b019f1e5a97c21ac1a4a4c63b6be38f ]

Ordinary opens initialize their allocation size from stat.blocks.
Buffered writes can leave delayed allocation pending, so separate handles
can cache different block counts for the same file.

This makes generic/568 fail when a zero write used for fallocate
emulation is followed by an overwrite of the same range. The first query
can report the pre-writeback block count, while the second query reports
the block count after delayed allocation is completed.

Complete writeback and refresh the cached block count before returning
allocation information for ordinary opens. Track client-specified
allocation sizes separately so CREATE allocation contexts and
FILE_ALLOCATION_INFORMATION continue to return the requested value.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Stable-dep-of: aad7d86a6651 ("ksmbd: round SetAllocation to the advertised allocation unit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c   | 38 ++++++++++++++++++++++++++++++--------
 fs/smb/server/vfs_cache.h |  1 +
 2 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 9a63dd0df84d5..e84f0cad2ec6a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3688,6 +3688,7 @@ int smb2_open(struct ksmbd_work *work)
 				goto err_out1;
 			}
 			alloc_size = le64_to_cpu(az_req->AllocationSize);
+			fp->allocation_size_set = true;
 			ksmbd_debug(SMB,
 				    "request smb2 create allocate size : %llu\n",
 				    alloc_size);
@@ -5077,6 +5078,30 @@ static int get_file_basic_info(struct smb2_query_info_rsp *rsp,
 	return 0;
 }
 
+static int get_file_allocation_stat(struct ksmbd_file *fp, struct kstat *stat)
+{
+	int ret;
+
+	/*
+	 * Buffered writes can leave delayed allocation in a state where two
+	 * consecutive queries report different block counts even when the
+	 * second write only overwrites the first one. Complete writeback before
+	 * reporting the filesystem allocation for an ordinary open.
+	 */
+	if (!fp->allocation_size_set) {
+		ret = file_write_and_wait(fp->filp);
+		if (ret)
+			return ret;
+	}
+
+	ret = vfs_getattr(&fp->filp->f_path, stat, STATX_BASIC_STATS,
+			  AT_STATX_SYNC_AS_STAT);
+	if (!ret && !fp->allocation_size_set)
+		fp->allocation_size = S_ISDIR(stat->mode) ? 0 : stat->blocks << 9;
+
+	return ret;
+}
+
 static int get_file_standard_info(struct smb2_query_info_rsp *rsp,
 				  struct ksmbd_file *fp, void *rsp_org)
 {
@@ -5085,8 +5110,7 @@ static int get_file_standard_info(struct smb2_query_info_rsp *rsp,
 	struct kstat stat;
 	int ret;
 
-	ret = vfs_getattr(&fp->filp->f_path, &stat, STATX_BASIC_STATS,
-			  AT_STATX_SYNC_AS_STAT);
+	ret = get_file_allocation_stat(fp, &stat);
 	if (ret)
 		return ret;
 
@@ -5153,8 +5177,7 @@ static int get_file_all_info(struct ksmbd_work *work,
 		return -EINVAL;
 	}
 
-	ret = vfs_getattr(&fp->filp->f_path, &stat, STATX_BASIC_STATS,
-			  AT_STATX_SYNC_AS_STAT);
+	ret = get_file_allocation_stat(fp, &stat);
 	if (ret) {
 		kfree(filename);
 		return ret;
@@ -5368,8 +5391,7 @@ static int get_file_network_open_info(struct smb2_query_info_rsp *rsp,
 		return -EACCES;
 	}
 
-	ret = vfs_getattr(&fp->filp->f_path, &stat, STATX_BASIC_STATS,
-			  AT_STATX_SYNC_AS_STAT);
+	ret = get_file_allocation_stat(fp, &stat);
 	if (ret)
 		return ret;
 
@@ -5495,8 +5517,7 @@ static int find_file_posix_info(struct smb2_query_info_rsp *rsp,
 		return -EACCES;
 	}
 
-	ret = vfs_getattr(&fp->filp->f_path, &stat, STATX_BASIC_STATS,
-			  AT_STATX_SYNC_AS_STAT);
+	ret = get_file_allocation_stat(fp, &stat);
 	if (ret)
 		return ret;
 
@@ -6593,6 +6614,7 @@ static int set_file_allocation_info(struct ksmbd_work *work,
 	}
 
 	fp->allocation_size = le64_to_cpu(file_alloc_info->AllocationSize);
+	fp->allocation_size_set = true;
 	return 0;
 }
 
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 7cfdc1140560c..03494f2627cd6 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -107,6 +107,7 @@ struct ksmbd_file {
 
 	bool				is_nt_open;
 	bool				attrib_only;
+	bool				allocation_size_set;
 
 	char				client_guid[16];
 	char				create_guid[16];
-- 
2.53.0



