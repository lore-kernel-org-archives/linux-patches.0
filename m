Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063656;
	b=NvdXkN2YuqNvj5pnkddvYXybuqf2R5fsM702ucIpP49FN/v/BiK4XU8BVEMKXfbo1VJG
	 puIqYx7go1A9/Irlnm6ntUA0aXzBlb1W2v75LHO43M4Xf42s7d2mI/9JeR/VWv9+39stV
	 usdvxBsDVQvO8BEZb5c3CHr0J1Q6Ok8o/5LoyYoXpRZjtC7Oms+N8MbC7QkRCcf6KWeSr
	 ktxMNH2uk/a/RuS9yyZIe4guV6znpp/h+yAni0IzCqrEob/Uo6aN//HD2ftEL4sswr75J
	 LE9movJ22ySicWleVQyx4H3evTVciUWHWoznmw4TMrlBQxK95t/D7Gi13me55eKenxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063656;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=amBOvVAtCCXo8fcoW1rg0LB9JiJoBnnecSmMsTI8N5Q=;
	b=JcdgJXykLS4c4e6z+pXDE0RvWWXcVCYYkUD0Ej+/Ks+NY0ruzlSaIA844FvhzW8u125M
	 uyFDpJudj/Wd0+JiPdT8PciekokOZWkg7ovE/NFjyEOeeuIE67y1f4z+eHvNhBQNDcuYN
	 i6ezb7w5D5oIxaQRTGZ4y+mU0RSkGLF6rqVRyOiqqOs9jFjOv/jNWQF06POLWrFWYCCHo
	 OT3pVmeAOnN4+4UzDFWTl2wjztMYgVKKtazPcnsp/IZ5ZfxPu2npNItJb2fhI+SlBOKYH
	 dTT/kKSzdwb2issStKys69jyfokTJF9twtX5S+Aql4Rv3PsmUl0HJD2nwH1ev/RgKJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=poRtb3uZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11E7606D827;
	Sat,  7 Nov 2026 15:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=poRtb3uZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 594181F008A1;
	Sat,  7 Nov 2026 15:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063655;
	bh=amBOvVAtCCXo8fcoW1rg0LB9JiJoBnnecSmMsTI8N5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=poRtb3uZutPYgPHbez3Q/lQI6+y9xfvy8gB625DxdXnd5vR73GrX703RgM3WckzXE
	 awaXdQ7fQbW0F/clrDZYgiiwxPxoyFIaB9/rVwx0kdqas+0GrxlaDoGHMwTful/QcN
	 1bQF+MON2hZQdsvFvlSQBoYSJeA52ZxA/PQa9HGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delu <jeandelu@tutamail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 721/869] parisc: eisa_enumerator: Fix out-of-bounds reads of the EEPROM buffer
Date: Sat,  7 Nov 2026 08:56:43 -0500
Message-ID: <20261107134917.276528629@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delu <jeandelu@tutamail.com>

[ Upstream commit c0a3e153804f0c14f4159ddbd2b73483c9cb3577 ]

eisa_enumerator() trusts the contents of the EISA EEPROM.  The number
of slots is read from the EEPROM header and used to access the slot
records at HPEE_SLOT_INFO(i) = 20 + 48*i within the fixed-size
eeprom_buf (HPEE_MAX_LENGTH, 8192 bytes) without any bound check.  As
struct eeprom_eisa_slot_info is 48 bytes, only 170 records fit into the
buffer, but num_slots is a u8 and may be up to 255, so a corrupted
EEPROM makes the code read up to about 4 kB past the end of the buffer
(e.g. record 254 is accessed at offset 20 + 48*254 = 12212).

parse_slot_config() has the same kind of problem: it clamps
config_data_length against HPEE_MAX_LENGTH but does not take
config_data_offset into account, so the parser can walk past the end of
the buffer even when the offset itself is valid.

Clamp the number of slots so that all slot records fit into the buffer,
and hand the number of bytes actually available to parse_slot_config()
and bound the parse by it.

Signed-off-by: Jean Delu <jeandelu@tutamail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/parisc/eisa_enumerator.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/parisc/eisa_enumerator.c b/drivers/parisc/eisa_enumerator.c
index f0cb31198a8f0..aa41d3abc6c22 100644
--- a/drivers/parisc/eisa_enumerator.c
+++ b/drivers/parisc/eisa_enumerator.c
@@ -311,6 +311,7 @@ static int configure_function(const unsigned char *buf, int *more)
 
 static int parse_slot_config(int slot,
 			     const unsigned char *buf,
+			     unsigned int buflen,
 			     struct eeprom_eisa_slot_info *es, 
 			     struct resource *io_parent,
 			     struct resource *mem_parent)
@@ -333,8 +334,8 @@ static int parse_slot_config(int slot,
 	printk(KERN_INFO "EISA slot %d: %s %s ", 
 	       slot, board, es->flags&HPEE_FLAG_BOARD_IS_ISA ? "ISA" : "EISA");
 	
-	maxlen = es->config_data_length < HPEE_MAX_LENGTH ?
-			 es->config_data_length : HPEE_MAX_LENGTH;
+	/* never parse beyond the data that is actually in the buffer */
+	maxlen = min_t(unsigned int, es->config_data_length, buflen);
 	while ((pos < maxlen) && (num_func <= es->num_functions)) {
 		pos+=configure_function(buf+pos, &function_len); 
 		
@@ -491,6 +492,13 @@ int eisa_enumerator(unsigned long eeprom_addr,
 	printk(KERN_INFO "Enumerating EISA bus\n");
 		    	
 	eh = (struct eeprom_header*)(eeprom_buf);
+	/*
+	 * The EEPROM contents are not to be trusted: clamp the number of
+	 * slots so that all slot records fit into eeprom_buf.
+	 */
+	eh->num_slots = min_t(u8, eh->num_slots,
+				(HPEE_MAX_LENGTH - sizeof(*eh)) /
+				sizeof(struct eeprom_eisa_slot_info));
 	for (i=0;i<eh->num_slots;i++) {
 		struct eeprom_eisa_slot_info *es;
 		
@@ -503,7 +511,8 @@ int eisa_enumerator(unsigned long eeprom_addr,
 		
 		if (es->config_data_offset < HPEE_MAX_LENGTH) {
 			if (parse_slot_config(i+1, &eeprom_buf[es->config_data_offset],
-					      es, io_parent, mem_parent)) {
+						HPEE_MAX_LENGTH - es->config_data_offset,
+						es, io_parent, mem_parent)) {
 				return -1;
 			}
 		} else {
-- 
2.53.0



