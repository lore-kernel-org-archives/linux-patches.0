Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB2226B080;
	Thu, 13 Feb 2025 15:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459441; cv=none; b=GTgtKiHABfdQxD+BJrbjljfVvQ7zRz3byoaYWq/xdLXiZv91VCOG4PDjzEMFdxTwvUxdtslXhRqk7eHxLLjEF/ZdyXR1rj6w+AHOow/RWfZTFm0f6s5Cj8hLsYzstwD36GSuv5TN+XHlpPcEb1Xgv/HMz6OFucQxtRs8DH3ryrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459441; c=relaxed/simple;
	bh=S0pivy+8wCRRm7EnC+Om5wuE+C5aIfAq3BtMqlVF3dI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbzKzEXSAb6N2WTrLo89Skz4UP3I9MEJc/YdVIUMkTFtc3xU/pmyJS6OJY9Oe11bHC1yvpArLib+do93Hub/kTJg/8pQD60VfqqeO+RajEuwA64F9b+lDk/YeCovhPhluvFqiQH+9fbLQiwocye7V0DjyJn9ERfN3G3czwJd43c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DNumvWfv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DNumvWfv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385BBC4CED1;
	Thu, 13 Feb 2025 15:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459440;
	bh=S0pivy+8wCRRm7EnC+Om5wuE+C5aIfAq3BtMqlVF3dI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DNumvWfvn3hjGHxJlQcsn0dqQ6udwS1uVYmOmw9icaal+6jvqeGRpS0mJv8kcLX3O
	 Auf5oyaJaHdSRLh+2QlRFpCaJvzZI5z1e2LBXR/6TQc0+44WebxXJ+OGW2DISWX6Kd
	 WLwJ5YT8plbxmLfgn5RQ5+NzEKeskvFBCM0EgJ2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.13 265/443] firmware: qcom: scm: Fix missing read barrier in qcom_scm_is_available()
Date: Thu, 13 Feb 2025 15:27:10 +0100
Message-ID: <20250213142450.842400071@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 0a744cceebd0480cb39587b3b1339d66a9d14063 upstream.

Commit 2e4955167ec5 ("firmware: qcom: scm: Fix __scm and waitq
completion variable initialization") introduced a write barrier in probe
function to store global '__scm' variable.  It also claimed that it
added a read barrier, because as we all known barriers are paired (see
memory-barriers.txt: "Note that write barriers should normally be paired
with read or address-dependency barriers"), however it did not really
add it.

The offending commit used READ_ONCE() to access '__scm' global which is
not a barrier.

The barrier is needed so the store to '__scm' will be properly visible.
This is most likely not fatal in current driver design, because missing
read barrier would mean qcom_scm_is_available() callers will access old
value, NULL.  Driver does not support unbinding and does not correctly
handle probe failures, thus there is no risk of stale or old pointer in
'__scm' variable.

However for code correctness, readability and to be sure that we did not
mess up something in this tricky topic of SMP barriers, add a read
barrier for accessing '__scm'.  Change also comment from useless/obvious
what does barrier do, to what is expected: which other parts of the code
are involved here.

Fixes: 2e4955167ec5 ("firmware: qcom: scm: Fix __scm and waitq completion variable initialization")
Cc: stable@vger.kernel.org
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20241209-qcom-scm-missing-barriers-and-all-sort-of-srap-v2-1-9061013c8d92@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/qcom/qcom_scm.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -1867,7 +1867,8 @@ static int qcom_scm_qseecom_init(struct
  */
 bool qcom_scm_is_available(void)
 {
-	return !!READ_ONCE(__scm);
+	/* Paired with smp_store_release() in qcom_scm_probe */
+	return !!smp_load_acquire(&__scm);
 }
 EXPORT_SYMBOL_GPL(qcom_scm_is_available);
 
@@ -2024,7 +2025,7 @@ static int qcom_scm_probe(struct platfor
 	if (ret)
 		return ret;
 
-	/* Let all above stores be available after this */
+	/* Paired with smp_load_acquire() in qcom_scm_is_available(). */
 	smp_store_release(&__scm, scm);
 
 	irq = platform_get_irq_optional(pdev, 0);


