Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C724119E7E1;
	Thu,  6 Jun 2024 14:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683110; cv=none; b=ehsL/dXCwcQ8WiiuYqttW08SQ2GDOP8cQ+eMRath41/HMWDMQghczg+DV3BUHXsoEcbT21AFRoyye239zeQMX1+w+tXe5FFmlxxmXs3c7UGvw9un5UHoZzaEHWUD2eJVJE1tVpjY9+Awq9uUvayR1NXRTKcR0WtECBxHCz0GF8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683110; c=relaxed/simple;
	bh=2+LirKC7gYCMMyyWIKO8Raw9Sp3q84V77G6vMQExRFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZ+d49Qne28UWUrqWRUh4LyHTeb8tlwVFf6VNnxEIFqc0mesjW4S9Q1w/tmyY4WJr8sSGT+y+JZr+kTXV4wjf2kJo8FsLxgq7ZBMbB1HsA0S71ti0aYBn7dZFRzAEypFEpPzHxcEAdQcHha232ew2FKT8JnrileAhTh9YkIiMRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YENWiYlR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YENWiYlR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60A6C2BD10;
	Thu,  6 Jun 2024 14:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683110;
	bh=2+LirKC7gYCMMyyWIKO8Raw9Sp3q84V77G6vMQExRFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YENWiYlROnooH25GEU1bPiPw2i0iTq9cUtYvePCmnwE3H2BUO3cV7y9fvUxqaLHWx
	 u00Uwhq/8Lu63Ppc5X9I+MKZwoBgG/2kxdWkkE5XNK0nmqmcHgfB0+EKEeoZqz1FRU
	 rRF8v5Yoy+m2vFUtYXAyyYF8Bsls/8ran57NTpCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Andryuk <jandryuk@gmail.com>,
	Peter Hutterer <peter.hutterer@who-t.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 009/744] Input: try trimming too long modalias strings
Date: Thu,  6 Jun 2024 15:54:41 +0200
Message-ID: <20240606131732.750188335@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 0774d19038c496f0c3602fb505c43e1b2d8eed85 upstream.

If an input device declares too many capability bits then modalias
string for such device may become too long and not fit into uevent
buffer, resulting in failure of sending said uevent. This, in turn,
may prevent userspace from recognizing existence of such devices.

This is typically not a concern for real hardware devices as they have
limited number of keys, but happen with synthetic devices such as
ones created by xen-kbdfront driver, which creates devices as being
capable of delivering all possible keys, since it doesn't know what
keys the backend may produce.

To deal with such devices input core will attempt to trim key data,
in the hope that the rest of modalias string will fit in the given
buffer. When trimming key data it will indicate that it is not
complete by placing "+," sign, resulting in conversions like this:

old: k71,72,73,74,78,7A,7B,7C,7D,8E,9E,A4,AD,E0,E1,E4,F8,174,
new: k71,72,73,74,78,7A,7B,7C,+,

This should allow existing udev rules continue to work with existing
devices, and will also allow writing more complex rules that would
recognize trimmed modalias and check input device characteristics by
other means (for example by parsing KEY= data in uevent or parsing
input device sysfs attributes).

Note that the driver core may try adding more uevent environment
variables once input core is done adding its own, so when forming
modalias we can not use the entire available buffer, so we reduce
it by somewhat an arbitrary amount (96 bytes).

Reported-by: Jason Andryuk <jandryuk@gmail.com>
Reviewed-by: Peter Hutterer <peter.hutterer@who-t.net>
Tested-by: Jason Andryuk <jandryuk@gmail.com>
Link: https://lore.kernel.org/r/ZjAWMQCJdrxZkvkB@google.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/input.c |  104 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 89 insertions(+), 15 deletions(-)

--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1378,19 +1378,19 @@ static int input_print_modalias_bits(cha
 				     char name, const unsigned long *bm,
 				     unsigned int min_bit, unsigned int max_bit)
 {
-	int len = 0, i;
+	int bit = min_bit;
+	int len = 0;
 
 	len += snprintf(buf, max(size, 0), "%c", name);
-	for (i = min_bit; i < max_bit; i++)
-		if (bm[BIT_WORD(i)] & BIT_MASK(i))
-			len += snprintf(buf + len, max(size - len, 0), "%X,", i);
+	for_each_set_bit_from(bit, bm, max_bit)
+		len += snprintf(buf + len, max(size - len, 0), "%X,", bit);
 	return len;
 }
 
-static int input_print_modalias(char *buf, int size, const struct input_dev *id,
-				int add_cr)
+static int input_print_modalias_parts(char *buf, int size, int full_len,
+				      const struct input_dev *id)
 {
-	int len;
+	int len, klen, remainder, space;
 
 	len = snprintf(buf, max(size, 0),
 		       "input:b%04Xv%04Xp%04Xe%04X-",
@@ -1399,8 +1399,48 @@ static int input_print_modalias(char *bu
 
 	len += input_print_modalias_bits(buf + len, size - len,
 				'e', id->evbit, 0, EV_MAX);
-	len += input_print_modalias_bits(buf + len, size - len,
+
+	/*
+	 * Calculate the remaining space in the buffer making sure we
+	 * have place for the terminating 0.
+	 */
+	space = max(size - (len + 1), 0);
+
+	klen = input_print_modalias_bits(buf + len, size - len,
 				'k', id->keybit, KEY_MIN_INTERESTING, KEY_MAX);
+	len += klen;
+
+	/*
+	 * If we have more data than we can fit in the buffer, check
+	 * if we can trim key data to fit in the rest. We will indicate
+	 * that key data is incomplete by adding "+" sign at the end, like
+	 * this: * "k1,2,3,45,+,".
+	 *
+	 * Note that we shortest key info (if present) is "k+," so we
+	 * can only try to trim if key data is longer than that.
+	 */
+	if (full_len && size < full_len + 1 && klen > 3) {
+		remainder = full_len - len;
+		/*
+		 * We can only trim if we have space for the remainder
+		 * and also for at least "k+," which is 3 more characters.
+		 */
+		if (remainder <= space - 3) {
+			/*
+			 * We are guaranteed to have 'k' in the buffer, so
+			 * we need at least 3 additional bytes for storing
+			 * "+," in addition to the remainder.
+			 */
+			for (int i = size - 1 - remainder - 3; i >= 0; i--) {
+				if (buf[i] == 'k' || buf[i] == ',') {
+					strcpy(buf + i + 1, "+,");
+					len = i + 3; /* Not counting '\0' */
+					break;
+				}
+			}
+		}
+	}
+
 	len += input_print_modalias_bits(buf + len, size - len,
 				'r', id->relbit, 0, REL_MAX);
 	len += input_print_modalias_bits(buf + len, size - len,
@@ -1416,12 +1456,25 @@ static int input_print_modalias(char *bu
 	len += input_print_modalias_bits(buf + len, size - len,
 				'w', id->swbit, 0, SW_MAX);
 
-	if (add_cr)
-		len += snprintf(buf + len, max(size - len, 0), "\n");
-
 	return len;
 }
 
+static int input_print_modalias(char *buf, int size, const struct input_dev *id)
+{
+	int full_len;
+
+	/*
+	 * Printing is done in 2 passes: first one figures out total length
+	 * needed for the modalias string, second one will try to trim key
+	 * data in case when buffer is too small for the entire modalias.
+	 * If the buffer is too small regardless, it will fill as much as it
+	 * can (without trimming key data) into the buffer and leave it to
+	 * the caller to figure out what to do with the result.
+	 */
+	full_len = input_print_modalias_parts(NULL, 0, 0, id);
+	return input_print_modalias_parts(buf, size, full_len, id);
+}
+
 static ssize_t input_dev_show_modalias(struct device *dev,
 				       struct device_attribute *attr,
 				       char *buf)
@@ -1429,7 +1482,9 @@ static ssize_t input_dev_show_modalias(s
 	struct input_dev *id = to_input_dev(dev);
 	ssize_t len;
 
-	len = input_print_modalias(buf, PAGE_SIZE, id, 1);
+	len = input_print_modalias(buf, PAGE_SIZE, id);
+	if (len < PAGE_SIZE - 2)
+		len += snprintf(buf + len, PAGE_SIZE - len, "\n");
 
 	return min_t(int, len, PAGE_SIZE);
 }
@@ -1641,6 +1696,23 @@ static int input_add_uevent_bm_var(struc
 	return 0;
 }
 
+/*
+ * This is a pretty gross hack. When building uevent data the driver core
+ * may try adding more environment variables to kobj_uevent_env without
+ * telling us, so we have no idea how much of the buffer we can use to
+ * avoid overflows/-ENOMEM elsewhere. To work around this let's artificially
+ * reduce amount of memory we will use for the modalias environment variable.
+ *
+ * The potential additions are:
+ *
+ * SEQNUM=18446744073709551615 - (%llu - 28 bytes)
+ * HOME=/ (6 bytes)
+ * PATH=/sbin:/bin:/usr/sbin:/usr/bin (34 bytes)
+ *
+ * 68 bytes total. Allow extra buffer - 96 bytes
+ */
+#define UEVENT_ENV_EXTRA_LEN	96
+
 static int input_add_uevent_modalias_var(struct kobj_uevent_env *env,
 					 const struct input_dev *dev)
 {
@@ -1650,9 +1722,11 @@ static int input_add_uevent_modalias_var
 		return -ENOMEM;
 
 	len = input_print_modalias(&env->buf[env->buflen - 1],
-				   sizeof(env->buf) - env->buflen,
-				   dev, 0);
-	if (len >= (sizeof(env->buf) - env->buflen))
+				   (int)sizeof(env->buf) - env->buflen -
+					UEVENT_ENV_EXTRA_LEN,
+				   dev);
+	if (len >= ((int)sizeof(env->buf) - env->buflen -
+					UEVENT_ENV_EXTRA_LEN))
 		return -ENOMEM;
 
 	env->buflen += len;


