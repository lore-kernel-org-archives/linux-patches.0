Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705704;
	b=HVD3noOefCzwYwxU3u4G1Of8iMz8wVMHvzcpTS5p6gt43fPG9pdyGX5WjT/sOO1d2Y2t
	 Utw924abFgcFLyMKaOV9IyPQNxN2Rj56IIkXyG0AI5LYQwcInR0wFreCWvWUYhqfR47JD
	 j3O5fdzgppQLKSV1KW/txlsMmsK1ii9TPQVK659IDH8VF23rHaeixPOHNT1Og76a8NXt3
	 lsYgULNs3qrkquqxO07LyAd9VZUD1oanrpV8fPv7cqZRIjN4FhC0ddSA/akcM7zFIePz8
	 wL0NfZxD+nz5CSfeWRU5NMxDxS6eXdaHmnOCk5x4tQ//SktToJL6M5Q/1YEwvngEG2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705704;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MIRXPXVZm7GEJbkuXAmL4ieSL549D5jvJBJQEfAsSjM=;
	b=uMnG3TCfh4tpWiWuqpondeg5XAny5ZLw/QHB4xtzPwp98IUusPo+CxL+/u2K3k1k41K/
	 /MzdlbuJqmPDYnZZzh3g4JYe0vx+XNYhoLX4+0gIpFQUiDz6HLeyxHWG/evsL53z62k7S
	 JY6fxXf89R5SsMNmC48mcPTYGTVkmY4IJIe41l0XFXd1QcIUPZTOsxkiKONjHKi/2/b8i
	 j6OgbUAtrK5jb76Um3H+wcdHZqy38F0qiT+6nxaM1SIq31AuRMh4wZdQ/vAb/7sZ2LcKK
	 bMKcgk7sR/FSQdQl863Ini9KsHy7bwtPQuFfRC40D+EdoaB+86xpdfEe/l2n1ZvvE6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vAScJxmi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774DF606A334;
	Thu, 26 Nov 2026 15:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vAScJxmi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3FB1F000C4;
	Thu, 26 Nov 2026 15:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705704;
	bh=MIRXPXVZm7GEJbkuXAmL4ieSL549D5jvJBJQEfAsSjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vAScJxmiPe6fWLFfpD684+uCoCSclCaF1awXmO/YiMDLB/095X0PUb2aZQLx/ak84
	 RUCS1/ElaD/5ibwmN6X6FHICkNoWjOJ0MdlEEFPxyGbYgDSmBP7Oq1lmkbJWbkbmAL
	 AOntVkQ1ARyyPkzSfWJy2mkJMpwfdNSG1j7PCOlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Subject: [PATCH 5.15 287/319] w1: w1_therm: leave the slaves of other families alone
Date: Thu, 26 Nov 2026 15:40:55 +0100
Message-ID: <20261126144013.236741594@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit c0eadd2e06e52563cae2b80491e56eb9712eb727 upstream.

The file therm_bulk_read belongs to the bus master.  Its callbacks walk
all the slaves of the bus and look at sl->family_data as if every slave
were a temperature sensor.  A 1-wire bus can carry other devices too:

- The family data of a slave which is driven by another driver, such as
  w1_ds2433, w1_ds250x, w1_ds28e04 or w1_ds28e17, is a structure of that
  driver.  bulk_read_support() takes whatever is at the offset of
  specific_functions for a pointer and dereferences it, and if the
  result happens not to be 0, the callbacks write the state of the
  conversion into that foreign structure.

- For a slave without family data, which is the case for most of the
  other drivers and for the default family, trigger_bulk_read() gives up
  with -ENODEV.  A single serial number chip on the bus is enough to
  make the bulk read unusable for all the sensors.

Only look at the slaves whose family is one of ours.  A bulk conversion
now works on a bus with other devices.

Fixes: 57c76221d5af ("w1_therm: adding bulk read support to trigger multiple conversion on bus")
Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20261027-llm-char-misc-w1-v1-9-d2e6bfafb6a4@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/w1/slaves/w1_therm.c |   37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -851,6 +851,19 @@ static inline bool bulk_read_support(str
 }
 
 /**
+ * bulk_read_slave() - check if a slave of the bus takes part in a bulk read
+ * @sl: any slave on the list of the master
+ *
+ * The family data of the slaves of other families is none of our business.
+ *
+ * Return: true if it is one of our devices and supports bulk read
+ */
+static bool bulk_read_slave(struct w1_slave *sl)
+{
+	return device_family(sl) && sl->family_data && bulk_read_support(sl);
+}
+
+/**
  * conversion_time() - get the Tconv for the slave
  * @sl: device to get the conversion time
  *
@@ -1441,9 +1454,7 @@ static int trigger_bulk_read(struct w1_m
 	 * so we can apply a strong pullup if required
 	 */
 	list_for_each_entry(sl, &dev_master->slist, w1_slave_entry) {
-		if (!sl->family_data)
-			goto error;
-		if (bulk_read_support(sl)) {
+		if (bulk_read_slave(sl)) {
 			int t_cur = conversion_time(sl);
 
 			t_conv = t_cur > t_conv ? t_cur : t_conv;
@@ -1481,7 +1492,7 @@ static int trigger_bulk_read(struct w1_m
 			/* set a flag to instruct that converT pending */
 			list_for_each_entry(sl,
 				&dev_master->slist, w1_slave_entry) {
-				if (bulk_read_support(sl))
+				if (bulk_read_slave(sl))
 					SLAVE_CONVERT_TRIGGERED(sl) = -1;
 			}
 
@@ -1510,7 +1521,7 @@ mt_unlock:
 set_flag:
 	/* set a flag to register convsersion is done */
 	list_for_each_entry(sl, &dev_master->slist, w1_slave_entry) {
-		if (bulk_read_support(sl))
+		if (bulk_read_slave(sl))
 			SLAVE_CONVERT_TRIGGERED(sl) = 1;
 	}
 error:
@@ -1878,16 +1889,14 @@ static ssize_t therm_bulk_read_show(stru
 	int ret = 0;
 
 	list_for_each_entry(sl, &dev_master->slist, w1_slave_entry) {
-		if (sl->family_data) {
-			if (bulk_read_support(sl)) {
-				if (SLAVE_CONVERT_TRIGGERED(sl) == -1) {
-					ret = -1;
-					goto show_result;
-				}
-				if (SLAVE_CONVERT_TRIGGERED(sl) == 1)
-					/* continue to check other slaves */
-					ret = 1;
+		if (bulk_read_slave(sl)) {
+			if (SLAVE_CONVERT_TRIGGERED(sl) == -1) {
+				ret = -1;
+				goto show_result;
 			}
+			if (SLAVE_CONVERT_TRIGGERED(sl) == 1)
+				/* continue to check other slaves */
+				ret = 1;
 		}
 	}
 show_result:


