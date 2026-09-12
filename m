Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4C4322C88;
	Sat, 12 Sep 2026 13:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221061; cv=none; b=VEL9wcWrrWpeaw6N4qZDjdWlDmW96niHR5e4E8YFZNfBLiFJUMGlmpD8Y52iQgqm5aHXWmFcuibA510QITcnsPLRHZrqzlyQjUNUl6PMffzQK6kzpllpSws5roOXbOb3IyBfwpCKuu9BOt+u6JIZ7NehDijk+L9+74301jW5ZyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221061; c=relaxed/simple;
	bh=t5hJaJhA60vrrwc4B+0wfo0uz5p3XOaKPh531adWmpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M6zZaNLH7+Bi2nCOVc6MxrCdB9SRzBT+zbgWEUV68GVwbpTmy1TTzrrB0FH7q5xXi2iej0KhwWYfmwCS5ZjvLtlUpyz5c5sKnZtdOIw5J6znrUc7+nFc0/IOO7Bwg4pQI7oZ26GIaHVfoBZYgFpuxFCDVbc0BqmHNjGsJLOxAJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LhCyrz4s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LhCyrz4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0EBB1F000FF;
	Sat, 12 Sep 2026 13:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221060;
	bh=T+2k+QyaUg9vN9Rt+GDz18vKWcPHgE3sSpfWSMRZi7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LhCyrz4sdf4R9MECzsYQ8Qq0YN6JoqOl0sHzZCm6OAPpj32cVqdXoRXaEbNpbo1HZ
	 HhzRRZGMmFmqN1Qg+Kn9yWf/YuHEoCDIwbsyLIw7wAlSLDWa1/VJoE0Ig5k/Hzjp/q
	 lQT8Xym3FBuS5OIZxmMu2HCyJKDGpx26SxuUiS80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 6.6 0299/1424] w1: ds28e17: reject an oversize length on an I2C block read
Date: Sat, 12 Sep 2026 08:45:31 +0200
Message-ID: <20260912065613.982291274@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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


