Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F7D41685A;
	Fri,  4 Sep 2026 05:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500238; cv=none; b=MR7doqNldp7Wp2qQ7tH9Jw33nDOrF7cjg+sK88z8WPPgIWe1Mlzw1IoNk0uhyH4lF8YmO8y4hFoz1hlbLlMTgyxS0o7go/nD+7wFbnooj70T41xykqdaNtU80A59OFUqldjRKc8RxBjK9d9jcGgRA9NsetSQo6MSlcCDDp4Zc00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500238; c=relaxed/simple;
	bh=vbOg4pX9jYA3BAihzVFTj1y5NXAZCEZQAlm3ZKceoQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vs23T14aldTKvzX2IaLFzniRRj9b1t0gdhtuA4MjgTv7d7rSBf8/4u+P3navtC10Ie0IdNMW75Tw17GLA7BEhWOoh+RxjTD3Rro7jShO3DXaFDr1MRuCJ7g4DiR5MnzKbP+C7XdI6G+LYsv7n8x7p6LGTMnJ91Tz5HlB2GC/wB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S/EZU73E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S/EZU73E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3651F00A3D;
	Fri,  4 Sep 2026 05:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500236;
	bh=VcUY+9i4F5NyTEbAwjKGAQYXVLBwTt73DiRrZSYdQLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S/EZU73E267mplh1XC/VjNuH6zNq/HcxRA/utLTZQy4Sgc9+hSRC8MHnApt5Vqf8K
	 KFYcYemifziBQ95fU9jOHzsH7h6HM3FzMtXKR3pniSRSfBd9sO026slBvrlOu1s8Gf
	 BkZDHZtho266WIEjsJsXIK5jKiPLzvcEC4QCzDyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 7.2 699/713] w1: ds28e17: reject an oversize length on an I2C block read
Date: Fri,  4 Sep 2026 07:01:07 +0200
Message-ID: <20260904045819.514836982@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maoyi Xie <maoyixie.tju@gmail.com>

commit 169ae5e65e5aaf213b6a578f6478a9fd2e523606 upstream.

w1_f19_i2c_master_transfer() is the master_xfer for the DS28E17 1-Wire
to I2C bridge. On an I2C_M_RECV_LEN read, it takes the length from the
device. The downstream slave puts a length byte in buf[0]. The driver
then reads that many bytes into buf[1] with w1_f19_i2c_read().

buf[0] is controlled by the device and can be 0 to 255.
w1_f19_i2c_read() only rejects a zero count. The caller buffer is
I2C_SMBUS_BLOCK_MAX + 2, so 34 bytes. A length above 32 makes the read
run past it, up to about 222 bytes out of bounds.

The SMBus core does check buf[0] against I2C_SMBUS_BLOCK_MAX. That
check runs after master_xfer returns. By then the write is already
done. i2c-algo-bit rejects an oversize length before it copies, and
returns -EPROTO.

Reject a length above I2C_SMBUS_BLOCK_MAX at both RECV_LEN sites, the
same way i2c-algo-bit does.

Fixes: ebc4768ac497 ("add w1_ds28e17 driver for the DS28E17 Onewire to I2C master bridge")
Cc: stable@vger.kernel.org
Signed-off-by: Maoyi Xie <maoyixie.tju@gmail.com>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20260629121043.199487-1-maoyixie.tju@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/w1/slaves/w1_ds28e17.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/w1/slaves/w1_ds28e17.c
+++ b/drivers/w1/slaves/w1_ds28e17.c
@@ -389,6 +389,10 @@ static int w1_f19_i2c_master_transfer(st
 			 * another simple read in that case.
 			 */
 			if (msgs[i+1].flags & I2C_M_RECV_LEN) {
+				if (msgs[i+1].buf[0] > I2C_SMBUS_BLOCK_MAX) {
+					i = -EPROTO;
+					goto error;
+				}
 				result = w1_f19_i2c_read(sl, msgs[i+1].addr,
 					&(msgs[i+1].buf[1]), msgs[i+1].buf[0]);
 				if (result < 0) {
@@ -415,6 +419,10 @@ static int w1_f19_i2c_master_transfer(st
 			 * another simple read in that case.
 			 */
 			if (msgs[i].flags & I2C_M_RECV_LEN) {
+				if (msgs[i].buf[0] > I2C_SMBUS_BLOCK_MAX) {
+					i = -EPROTO;
+					goto error;
+				}
 				result = w1_f19_i2c_read(sl,
 					msgs[i].addr,
 					&(msgs[i].buf[1]),


