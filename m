Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705573;
	b=nL/QSfX/tDhgANgT+G4+k1OAkhomyZj6Po1qfRvhz3Kyjal1qfB40QW3GV149GqZpT73
	 eEXd9ecNgVQdEjDSNql/QL30PcZ15l0i3C5zuei00XxV2Fox1IjRXCx+YFhEzcdhdj5/s
	 hAnvU5DTaLOs9+yPE+Ul7PYaEPz1Lwp85yVtkxxUYmxw15cwLsYDcQz4X/Yx1GMdtRKhx
	 faqUFicN/tz/ayJIeeeTZXJtjaG6rFfPpo6bbPx/yLcRBR/iypM/plOCt2hrCZeEOMWLR
	 TUCEf2GAmLPNpvSkLsz7ZCKNzztq3CVp7ToxkyJPI3Xu0nIeQNF8Stsams3vyp32YZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705573;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QtmLYkq8wQQgCPtOLHfZY9nkizSFivebFz9INZzQyMs=;
	b=G3/1v59ZQMtbFIVjVbA5GghCqQj0XVvv7fADQipn0G4ywz/Bf7SntJ3i1T2ubV2uskYi
	 EDjkVYms3FbZXbd1aWBucR1vNcJuQnoCe/eqDSU7IJ1pgOwxXqu7Pc8rhDZlLynp/P7cd
	 FjNPkduEs4c9pc8ulA67ZFFmJerefYc0FY7opXEvaMAsr3AH/URI9c80JYTKaujX/12iw
	 zenxy97nk02W940ClKwWbEjp3bScj6B4JtJxlNgOf584LOPChaliaITuL2N3dKkft6pB0
	 7znh7KJItemv/5GEMAbSKz72PdiMCZZbTW53SY1y2jY4vPZmay5amd2u2VvNli427pQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KawjnEsY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B91D606A327;
	Thu, 26 Nov 2026 15:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KawjnEsY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F971F000C6;
	Thu, 26 Nov 2026 15:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705572;
	bh=QtmLYkq8wQQgCPtOLHfZY9nkizSFivebFz9INZzQyMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KawjnEsYgPLB1iO/SaUpYKjcO2k794LbgIPCvoGSTOUIugCCdUpVmDtbD5TH54M7d
	 M2eujJgz7IZoLQt4MS+/tlC+AxxC7cJV7aN1LYoErNW4GtJ0tWES7L2OH9y7TL/utI
	 bl9QuqJ4r2KaqhLT1i376ckz/0P13Gi+o0mOIyt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 243/319] dm mpath: fix buffer overflow in parse_hw_handler()
Date: Thu, 26 Nov 2026 15:40:11 +0100
Message-ID: <20261126144012.229831985@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


