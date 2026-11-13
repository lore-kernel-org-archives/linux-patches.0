Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591587;
	b=mh0lQUl5Q+xgeTBcsRLFC7YJzLYOFSSACD5Sj6/FVb02G/Hq4lSePMOf9xg8wIFS6oMp
	 /Lv2RZAPF8hA6QnxnATazu4VbV8ti1CJYfsRvTrKE8O6z6n3FQrZCCR60SqRai6ocH98M
	 ZYkERxGWoQuqgMJOefznQkDJB/Qurqz9hUpS5KGr3sRh9sk9y1AijvoGLkcctIpSV0RS6
	 3k6MRtN1FuWXDp8171E9iyxsm8eyXIr51rQSqEf8zDK3g6SVX2pLscfOBw1KpEwz6MRf+
	 28VgcPqaQnjgr3/SCPXf9EclQPDjzY9HsKgdH+MkCuP+WK6brtO7t9igHM9EiCnVY4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591587;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dxi6wHnjUKcCpxVps8x/zCuePkpTydY5eAqcNPo6T+k=;
	b=Ben36p58oHg1HEVWj81THHyPx/NtABTopn5DTpFXUskEg7i14l/UtjIUpUL0AX5WsYAn
	 gOnAZJbTnh/2V9viHkUd9iwdsaJfbNvyIhkedK2QC+BfPslLvCzcvJ1Po+qI4Tp+sNit6
	 hXf9vZQA5l7MeHQyJjN31h3EgTE96Boic68osEsP33jU3TTRP3+G0vus9pGdbxRi6W412
	 TduyrUztAQF30q+xmNp0Sc9tBx48C1tnviZ26iJYbaMyWjTnsx3PxTJSUbiCfSmk5jNla
	 RkwyrIJIReO6gj55vy0eZW0MfQ8ruQ1lhmPa4ZuWEfIsEsmFoZXRsAsVSFeuOVylOdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U03Jz5MX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A78606E670;
	Fri, 13 Nov 2026 17:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U03Jz5MX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46201F000C5;
	Fri, 13 Nov 2026 17:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591587;
	bh=dxi6wHnjUKcCpxVps8x/zCuePkpTydY5eAqcNPo6T+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U03Jz5MXFlJkFl4sFhDqFxBdUjDnHiH3F63dBAO0YA3jefeCs12yr2MbXcGtTtvaL
	 /uoJ/HCP5f7OHDJkA3GKd5iSSsBl71xqul/duO2fQjxBl4MP+CIlCBlnqpkpuq/hr9
	 AK+k8u/vbNizx3G6gzk8pob86RPyswp+x0C7wAbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 633/670] ACPI: APEI: accumulate the queued flag across error sections
Date: Fri, 13 Nov 2026 10:53:17 -0500
Message-ID: <20261113153833.239022404@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit f341307a14895e5da056fb419a31ef7fb534ab18 ]

ghes_do_proc() walks every error section of a CPER record, and
ghes_handle_arm_hw_error() walks every error-info entry of an ARM
processor section.  Both assign to "queued" instead of OR-ing into it,
so only the last iteration counts: a later section or entry that queues
no memory-failure work clears the flag an earlier one set.

Instead of reassigning the variable at every time, just do an `OR`, so,
if there was a single match, it will return "queued" as set.

The comment above the check says "If no memory failure
work is queued", which is the semantics this patch implements. I.e, only
SIGBUS if there are queue was not handled at all. If we want to SIGBUS
if any event was not handled/queued at all, we will need something more
sophisticated.

Fixes: 7f17b4a121d0 ("ACPI: APEI: Kick the memory_failure() queue for synchronous errors")
Fixes: ccb5ecdc2dde ("ACPI: APEI: fix synchronous external aborts in user-mode")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Link: https://patch.msgid.link/20260925-ghes-queued-accumulate-v1-1-df50553957d4@debian.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[ sashal: Adjusted ARM handler context for missing adjacent CXL protocol error handling. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/apei/ghes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 03cf3d63e609c..045acf13c1313 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -583,7 +583,7 @@ static bool ghes_handle_arm_hw_error(struct acpi_hest_generic_data *gdata,
 		 * and don't filter out 'corrected' error here.
 		 */
 		if (is_cache && has_pa) {
-			queued = ghes_do_memory_failure(err_info->physical_fault_addr, flags);
+			queued |= ghes_do_memory_failure(err_info->physical_fault_addr, flags);
 			p += err_info->length;
 			continue;
 		}
@@ -809,11 +809,11 @@ static bool ghes_do_proc(struct ghes *ghes,
 			atomic_notifier_call_chain(&ghes_report_chain, sev, mem_err);
 
 			arch_apei_report_mem_error(sev, mem_err);
-			queued = ghes_handle_memory_failure(gdata, sev, sync);
+			queued |= ghes_handle_memory_failure(gdata, sev, sync);
 		} else if (guid_equal(sec_type, &CPER_SEC_PCIE)) {
 			ghes_handle_aer(gdata);
 		} else if (guid_equal(sec_type, &CPER_SEC_PROC_ARM)) {
-			queued = ghes_handle_arm_hw_error(gdata, sev, sync);
+			queued |= ghes_handle_arm_hw_error(gdata, sev, sync);
 		} else if (guid_equal(sec_type, &CPER_SEC_CXL_GEN_MEDIA_GUID)) {
 			struct cxl_cper_event_rec *rec = acpi_hest_get_payload(gdata);
 
-- 
2.53.0



