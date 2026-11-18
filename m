Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048805;
	b=b7xdCQyvLogMQNFxVl0TN3/eaatlf4xpULqZjwRgtGWwtblb3535Ebvq2R5IS3bdEUS+
	 X2D5OotqwEm7nafU4SWeh/Ms+pid6KJVOt6rD3On9Bo6FxvuYVInBnEXm14cgQpMDpfa7
	 k7y/QN+4xXHDBdyW+rSe9kPEqVi5oH7EVRIpK2lzzcXj98EwCPmkypyLQ4Mc4hBjio2uh
	 rQ3Ub8J5dUVt2rIL+L39aLJmjpnOiFFJSWGAcjflXuYY0BNwtgjWhee4AP4O3Vgw8sOgk
	 FbCL8UOCwzbM+uqhs3JWkM1+ISs5LTZeiyvOsTA53JJpBA5h2IDzts27fSszkg+V2Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048805;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IGKEiqH+m+mzu6jdhbvtnRVn+UB8F+0LplaUTWvlj30=;
	b=UR5CXOletM0idP+/WuS/nZtxombkiCX1KgmuoYrOhxausIWBYZdwBHrQL6WAn4yqRyRZ
	 PPe3DURxXCZNY1ZFPWEEHTb0jikkuWWAdHvtskgnWIQpahXypqweI7ouYhvDT0+I24fdE
	 2JSEzWaKelEwH/BGhwQJ358UIvY7NfxBCFxz3AOcl1DJHF7/xzRVqfLSjjD2uEuJMkU6B
	 CptqddTFxGheGqFSI46E+3DtZ2kutQK2CIvSZjaPjC0HcsK+Gbcfp05vWgwjd6iofsJnK
	 9Qrv/rzkO+G6r+i7M3Lm91ipWwKTFUexS3KBue1765HC5nr86tcxVnmHeR5ZplFzMHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U+cXVMeY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A163606A325;
	Thu, 19 Nov 2026 00:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U+cXVMeY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2A41F000C4;
	Thu, 19 Nov 2026 00:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048805;
	bh=IGKEiqH+m+mzu6jdhbvtnRVn+UB8F+0LplaUTWvlj30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U+cXVMeYCLkepTsjRnd1wIn1OLgMOC1NK92S5A2+1L/aOjAuNzr7O/EmTTdCHMj9S
	 tUywfsoND8bUGf9lf5hneScNhkBS1+ixNlg4gPqCZ7s4I7QiOoDTim0aRLlaChVEHS
	 RdCK/Vq4SW4NNUu4/hNsR0RMY27kVCRmEk/O3hww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2119/2857] fs/ntfs3: fix slab-out-of-bounds write in attr_insert_range()
Date: Wed, 18 Nov 2026 15:52:33 +0100
Message-ID: <20261118150317.702398234@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei (Microsoft) <xmei5@asu.edu>

[ Upstream commit bf9a6578e03b065335836e025356b4b9170b9449 ]

When fallocate(FALLOC_FL_INSERT_RANGE) grows a still-resident ntfs3
attribute, attr_insert_range() shifts the inline data using the insert
length 'bytes' as both the destination offset and the copy size:

  memmove(data + bytes, data, bytes);

Both are wrong: the shift must start at the insertion point 'vbo' and
move only the data past it (data_size - vbo). When bytes > data_size the
memmove runs off the end of the data_size + bytes buffer and overflows
the adjacent slab object.

Since vbo < data_size is already enforced above, the reworked offsets stay
within the data_size + bytes buffer and cannot under/overflow.

  BUG: KASAN: slab-out-of-bounds in attr_insert_range (fs/ntfs3/attrib.c:2581)
  Write of size 512 at addr ffff8880135e8b10 by task exploit/142
   ...
   __asan_memmove (mm/kasan/shadow.c:95)
   attr_insert_range (fs/ntfs3/attrib.c:2581)
   ntfs_fallocate (fs/ntfs3/file.c:618)
   vfs_fallocate (fs/open.c:338)
   __x64_sys_fallocate (fs/open.c:362)
   ...

Fixes: 9256ec35359f ("fs/ntfs3: Refactoring attr_insert_range to restore after errors")
Reported-by: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index 0ec6d8406a74c..503b38bd350b7 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -2414,8 +2414,8 @@ int attr_insert_range(struct ntfs_inode *ni, u64 vbo, u64 bytes)
 			/* Still resident. */
 			char *data = Add2Ptr(attr_b, attr_b->res.data_off);
 
-			memmove(data + bytes, data, bytes);
-			memset(data, 0, bytes);
+			memmove(data + vbo + bytes, data + vbo, data_size - vbo);
+			memset(data + vbo, 0, bytes);
 			goto done;
 		}
 
-- 
2.53.0



