Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704659;
	b=aiRd9wSQZEW3ZeqsK3eTQ5wjXyTVu7A30iF3eDjXgM1+0Gs52knn2lnmX77LXrmmlM/T
	 hOUQdG9GAXAN4gShM/nrhcugR/Ruphw7bQMbSGl67podb/9DfnfEIcKHfeB2vBWmYAscD
	 VxbFnkUW8FJwyurGDZK9X/IxLz7Z4oJMc3XPbh2WEoJh6u0zLD5+myiOomcWs1KcTHdFW
	 8J2cn4Zm23NPdC+GP+1dB4gyUfGp9N66GHH7xoKpgQmTuqCP6GblVLTgoXcJ0Ul2CH5R4
	 bRUSFJfZUf0ire0mpLYWiao985UIXYIv/NfrxPMTqHNfepx8na3aOOjw4uTibqcCT7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704659;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x8prQ6Ng6wm6Hg/iFSDPGqahKVgqDD2QHwWm6Oif9fo=;
	b=2AzrtFqTACZEaY4skmMn/NhXezTjI1qZyPIuVrEBTEz1wdZnIWX92ffdDAzzBVEK+Rkx
	 D+TxI2zWAsbwRhGhQIiK4yoHD5C0I2/JC5TC16xFwQ669xFBaByQRYfHJiIHWvexKtT1h
	 ZK38uR3g5mZnIQCpPJXjBnP5pxe92NxaoqPc/F/IoWNcG/ttD0QcWEmDmBoQ0AfcaLG4r
	 zH5QdvAMrEvLs9lOVQUDkSaTNZUh79PdxDYoAwGzygG6ST1im9cYNwGOMJMGcVXdb+2eI
	 irxGI6DkHcI6S7Q0zDkC+HyY2DVCnai/KQM3xsXvZguTH36pKYdMGHvSwut1Jex/Lcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="K/sFSQGu";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE70606A323;
	Thu, 26 Nov 2026 14:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K/sFSQGu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19AFE1F000C0;
	Thu, 26 Nov 2026 14:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704658;
	bh=x8prQ6Ng6wm6Hg/iFSDPGqahKVgqDD2QHwWm6Oif9fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K/sFSQGuMDqfw5Tdx9neWFL3Wlk4j15CXhiWE0ADn4NlP4stiFvSzeR39vI9TQxql
	 Wu+i2dqA2twRIM74sjlPRln1cCwId+D/MH3x1AnG2WYUZWWtE50YbAEyvrA7FQE2TU
	 9uwPVvux4iyFTqzcPNOPMzwagaznM8mbwetFwCJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 201/265] dm mpath: fix buffer overflow in parse_hw_handler()
Date: Thu, 26 Nov 2026 15:38:51 +0100
Message-ID: <20261126143619.277225060@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: shao.mingyin@zte.com.cn <shao.mingyin@zte.com.cn>

commit 8f611fe94a781c6fb658488cc7eab4e4923e6df6 upstream.

parse_hw_handler() builds the hw_handler parameter string in a buffer
sized with

	len = 4;

plus one byte per argument.  Those four bytes were meant for the decimal
form of the parameter count, three digits plus the terminating NUL.
dm_read_arg_group() accepts up to 1024 arguments and the count written is
'hw_argc - 1', so a count of 1000 or more needs four digits plus the NUL
and sprintf() writes one byte past the allocation.

Size the buffer from the actual string length instead.

Fixes: 2bfd2e1337f0 ("[SCSI] scsi_dh: Use scsi_dh_set_params() in multipath.")
Cc: stable@vger.kernel.org
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-mpath.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1074,8 +1074,9 @@ static int parse_hw_handler(struct dm_ar
 
 	if (hw_argc > 1) {
 		char *p;
-		int i, j, len = 4;
+		int i, j, len;
 
+		len = snprintf(NULL, 0, "%d", hw_argc - 1) + 1;
 		for (i = 0; i <= hw_argc - 2; i++)
 			len += strlen(as->argv[i]) + 1;
 		p = m->hw_handler_params = kzalloc(len, GFP_KERNEL);


