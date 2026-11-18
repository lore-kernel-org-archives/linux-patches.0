Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048512;
	b=GYv+myIriz4ENfR4PnyMSB/vOAkOLptmp05G68Yill+aRepjX6Vw0dA4sweFL635VzEF
	 vm8WEQJHzLT9MSumoTZZfIBjID5aKIAz1LXODzcFYZOqS3pUZ7ZqaUZt8VFYOtyHVP1H8
	 Qi3WLVr1KLOOEBUb4/0BWHGn19+6+gQJiiTNfds+uLRq8THWBQ9BI05WFnYipBaBXNBrz
	 LiVdZHUlI106n5jtY0KmhCAWpZ3TRuh1d7ZO0ooIMWxCFCpXXsS02zFnFHqZ+v5Wq+tcD
	 tPS+y7NhY6FlyDMgnRks+FM08wjEEQ+J7/uZYHkZ/Kmo0ngo28S3n3+be4eCghWxPDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048512;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2plnjsaK0PSU8ME/7z420CU7TCMBOuIF6MBHuv0O2iY=;
	b=Y1vEk7Zwv0X9J84PS1XpNlQadRKPLw3GJ6O3Sm+4tocUqvAAX3NXDACk2oF2uKBIsfqa
	 AHg5LpOoLTP8u7knsPTzk1T+jONqtaqvI1SdPlZu/orXJkU+KR7fGLrewxialI5VDTRDH
	 Aawl7cHlQeBaXelN8BrAi099xqDrk2daxsHCwnvpce6iEBQ6m0zD2ttVZO1Lvh0ghw80F
	 s5fl9cPJ7j71j0mjIXIk/ibrWNTMfLvhcuU7g4TTcpbfWSzG9ie3CeYVYlA+5t+mg3ZAi
	 OcGcO8an0kMQWB4iR5BsKoQpsqYhEhIY0oHrLOEtFYcHItv1EzA3yaGjNhLlk7CRk+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=08GvxXT7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D0D606A332;
	Thu, 19 Nov 2026 00:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=08GvxXT7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B5781F000C6;
	Thu, 19 Nov 2026 00:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048512;
	bh=2plnjsaK0PSU8ME/7z420CU7TCMBOuIF6MBHuv0O2iY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=08GvxXT7rMaTOs3SQfnxp5Q5yK0ZMeoWA5h7M8OMZhTEtirouRQQt7comflYMZE8V
	 JMPeTAUViL6ifbEkdnwRdSW/REDTXwljZFESfJS5B3HXju6C4o4HfDjSo3Y2Dfq4GO
	 Zn9/9ji572jCx4LBC15xWeakvGSuQ3p/GDlRZWWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2020/2857] swim: Check for CRC errors
Date: Wed, 18 Nov 2026 15:50:54 +0100
Message-ID: <20261118150314.135607895@linuxfoundation.org>
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

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 01bff87152e6748fbac9ccd645d3d5f490d75ddc ]

After reading either the sector header or sector data, examine that flag
in the handshake register which holds the result of the CRC calculation.
CRC validation has to take place with the last byte still in the FIFO.
This flag can't be checked by the caller because by then all bytes will
have been retrieved from the FIFO. Return an error code when appropriate.

Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/9bfcd0414192d1b95803c16701d62732ff6e8f3f.1788513997.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim_asm.S | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/block/swim_asm.S b/drivers/block/swim_asm.S
index 208622ac4aeb9..250e408060e8b 100644
--- a/drivers/block/swim_asm.S
+++ b/drivers/block/swim_asm.S
@@ -42,6 +42,8 @@
 	.equ	max_retry, 40
 	.equ	sector_size, 512
 
+	.equ	.Lhr_crc_error,		0x02
+
 	.global swim_read_sector_header
 swim_read_sector_header:
 	link	%a6, #0
@@ -134,6 +136,10 @@ crc1:	tstb	%a2@
 
 	moveb	%a3@, %a4@(o_crc1)
 
+	moveb	%a2@, %d5
+	andb	#.Lhr_crc_error, %d5
+	bne	signal_nonyb
+
 	tstb	%a3@(read_error - read_mark)
 
 	moveq	#0, %d0
@@ -226,6 +232,10 @@ data_crc1:
 
 	moveb	%a3@, %d5
 
+	moveb	%a2@, %d5
+	andb	#.Lhr_crc_error, %d5
+	bne	data_exit
+
 	tstb	%a3@(read_error - read_mark)
 
 	moveb	#0x18, %a3@(write_mode0 - read_mark)
-- 
2.53.0



