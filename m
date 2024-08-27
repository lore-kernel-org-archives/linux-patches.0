Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696EADDC1;
	Tue, 27 Aug 2024 14:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770161; cv=none; b=pIxpMcZZM5nS5ETKqH+CvrrIrCHi49NcOgx+vzZI73srAzSkQgSeesScPB/ye9u9Z1VdeojP9E7qVO5HUAjCjn/CogH+7Y77c9iI4pW8AtCXf9spS8MOfXghXi+1XESXzpJUCr0NqmhscUmXaRR4qprgbX4Xtk5/3ht4fO5SUhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770161; c=relaxed/simple;
	bh=ac0/S4cjGeTN5LUYQU4kYQU8aPU6Kl8e7ZGBc/zDP5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwb4ZOAUhrLNTDvbnq5JJIbyezj6UKfRxFProLDn4bwYpe22ns0nnxY7LxkdaT1POo0oIpUZTdxskGJWm3kYZxOPF7cVIGrC09jS1BDFM0L17WUIOJd6LyNRe1e8hvkTltHHU+hhjQXyLzf+lKri9SldwuqNbo6hejkiu6SfC4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IN+nh9+t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IN+nh9+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B905CC4AF13;
	Tue, 27 Aug 2024 14:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770161;
	bh=ac0/S4cjGeTN5LUYQU4kYQU8aPU6Kl8e7ZGBc/zDP5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IN+nh9+t/mnmtpi4QX40CW0M9mPKCrP97MWc7Q+78aXUCeSpXx1q+So8jW865wUNp
	 u5225ZAtfVCkfusjJhChBB4AvMfpGkuTgVC3uMDdzHP4+aZBMTKHI2j8GhprpudCO8
	 dFbon+Cc3jIUcEGksDxC4ILJn23tnF7gnaNZzFFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Lynch <nathanl@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 145/341] powerpc/pseries/papr-sysparm: Validate buffer object lengths
Date: Tue, 27 Aug 2024 16:36:16 +0200
Message-ID: <20240827143848.938452635@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit 35aae182bd7b422be3cefc08c12207bf2b973364 ]

The ability to get and set system parameters will be exposed to user
space, so let's get a little more strict about malformed
papr_sysparm_buf objects.

* Create accessors for the length field of struct papr_sysparm_buf.
  The length is always stored in MSB order and this is better than
  spreading the necessary conversions all over.

* Reject attempts to submit invalid buffers to RTAS.

* Warn if RTAS returns a buffer with an invalid length, clamping the
  returned length to a safe value that won't overrun the buffer.

These are meant as precautionary measures to mitigate both firmware
and kernel bugs in this area, should they arise, but I am not aware of
any.

Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231212-papr-sys_rtas-vs-lockdown-v6-10-e9eafd0c8c6c@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/papr-sysparm.c | 47 +++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/arch/powerpc/platforms/pseries/papr-sysparm.c b/arch/powerpc/platforms/pseries/papr-sysparm.c
index fedc61599e6cc..a1e7aeac74161 100644
--- a/arch/powerpc/platforms/pseries/papr-sysparm.c
+++ b/arch/powerpc/platforms/pseries/papr-sysparm.c
@@ -23,6 +23,46 @@ void papr_sysparm_buf_free(struct papr_sysparm_buf *buf)
 	kfree(buf);
 }
 
+static size_t papr_sysparm_buf_get_length(const struct papr_sysparm_buf *buf)
+{
+	return be16_to_cpu(buf->len);
+}
+
+static void papr_sysparm_buf_set_length(struct papr_sysparm_buf *buf, size_t length)
+{
+	WARN_ONCE(length > sizeof(buf->val),
+		  "bogus length %zu, clamping to safe value", length);
+	length = min(sizeof(buf->val), length);
+	buf->len = cpu_to_be16(length);
+}
+
+/*
+ * For use on buffers returned from ibm,get-system-parameter before
+ * returning them to callers. Ensures the encoded length of valid data
+ * cannot overrun buf->val[].
+ */
+static void papr_sysparm_buf_clamp_length(struct papr_sysparm_buf *buf)
+{
+	papr_sysparm_buf_set_length(buf, papr_sysparm_buf_get_length(buf));
+}
+
+/*
+ * Perform some basic diligence on the system parameter buffer before
+ * submitting it to RTAS.
+ */
+static bool papr_sysparm_buf_can_submit(const struct papr_sysparm_buf *buf)
+{
+	/*
+	 * Firmware ought to reject buffer lengths that exceed the
+	 * maximum specified in PAPR, but there's no reason for the
+	 * kernel to allow them either.
+	 */
+	if (papr_sysparm_buf_get_length(buf) > sizeof(buf->val))
+		return false;
+
+	return true;
+}
+
 /**
  * papr_sysparm_get() - Retrieve the value of a PAPR system parameter.
  * @param: PAPR system parameter token as described in
@@ -63,6 +103,9 @@ int papr_sysparm_get(papr_sysparm_t param, struct papr_sysparm_buf *buf)
 	if (token == RTAS_UNKNOWN_SERVICE)
 		return -ENOENT;
 
+	if (!papr_sysparm_buf_can_submit(buf))
+		return -EINVAL;
+
 	work_area = rtas_work_area_alloc(sizeof(*buf));
 
 	memcpy(rtas_work_area_raw_buf(work_area), buf, sizeof(*buf));
@@ -77,6 +120,7 @@ int papr_sysparm_get(papr_sysparm_t param, struct papr_sysparm_buf *buf)
 	case 0:
 		ret = 0;
 		memcpy(buf, rtas_work_area_raw_buf(work_area), sizeof(*buf));
+		papr_sysparm_buf_clamp_length(buf);
 		break;
 	case -3: /* parameter not implemented */
 		ret = -EOPNOTSUPP;
@@ -115,6 +159,9 @@ int papr_sysparm_set(papr_sysparm_t param, const struct papr_sysparm_buf *buf)
 	if (token == RTAS_UNKNOWN_SERVICE)
 		return -ENOENT;
 
+	if (!papr_sysparm_buf_can_submit(buf))
+		return -EINVAL;
+
 	work_area = rtas_work_area_alloc(sizeof(*buf));
 
 	memcpy(rtas_work_area_raw_buf(work_area), buf, sizeof(*buf));
-- 
2.43.0



