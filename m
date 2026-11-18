Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047215;
	b=VviWMWDmvGGyXi312qESIE7ALdQiT2fFJ2k2ZAU24OJNoF3qx4e/6D9pvNpiF7GWLJws
	 4HKGuu99Pr7PC6czynt88iJ5y5OFdVM+xr6IxUP7qRtUeca4J73ob2LOZU+lWYQSnkVan
	 rDAMZI74xFqKJJzQCuZgMij8ZHfIWgbCkfJpRx7sWdVbfQB40Wxehc+jVXsvIIBv4BohI
	 uCNxgIS201Q0+XPQbIYrpaBykAprxfxZM75CLE+0kc0oljN9/gwgT6a/yrTQuA/9H3rQy
	 iTUc9nwUf4Qw3Ip1O77On6YO+jSDvZKCnaBocK62XAb0Qw299eANxlai2nzrTT9OJCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047215;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S0T38U8YtJzlpvzBACXVWbHG056fIMho24JD0E8qQKE=;
	b=NsXos6j5D6ysBeflot/InfgDUQ8oFH2rorTolZEtg62MicgMipqVtphFBtOfFYe57D+Y
	 /pzWr/qwIn73ce+cdAZnyBkr3LKd+nvM36tGBJDrEEGVgivV78K+qOAthqewx/JDZOtRS
	 LAGoz+ZL6z6dmgMIcMcB0sijAzmrOz3uA6TDfZerEnfxh1k/UyhUH9bKqbyWn2IqJV2Yk
	 Oz+6TiAmbXgJc9jYn+29zlBgTJnWvQjjW/Kn+K5DfCBf3l3jivpzsp2Sw41AgmJ1jqPQw
	 3nJqCCsQXogauRxRyAOje5j4RZrb3bIj9sfMrAiCMi7GEphfclx702nhemBemM6A/bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YLAuhQ74;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18039606A339;
	Thu, 19 Nov 2026 00:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YLAuhQ74
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF481F000C4;
	Thu, 19 Nov 2026 00:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047214;
	bh=S0T38U8YtJzlpvzBACXVWbHG056fIMho24JD0E8qQKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YLAuhQ74EIwbjHESL0fibTArB1hR3fgFCE5BlaOv6H9aGmpHhFv62G+mpOwt0SA6x
	 wCQu5KOOXJbjTQVJN3IOBL3fjE4GMfikCEl6BE0ldRFzVEEvPRPzcQEY+rKyEqCbSg
	 yK+3gl7FNsK/YtDecTAnFFOegHPZM5kRc9/FT6wM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1560/2857] ACPI: APEI: accumulate the queued flag across error sections
Date: Wed, 18 Nov 2026 15:43:14 +0100
Message-ID: <20261118150257.559656210@linuxfoundation.org>
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
[ sashal: Adjusted patch context to match the older ghes_do_proc() implementation. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/apei/ghes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index fff97db7779ef..517ed5f77008f 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -529,7 +529,7 @@ static bool ghes_handle_arm_hw_error(struct acpi_hest_generic_data *gdata,
 		 * and don't filter out 'corrected' error here.
 		 */
 		if (is_cache && has_pa) {
-			queued = ghes_do_memory_failure(err_info->physical_fault_addr, flags);
+			queued |= ghes_do_memory_failure(err_info->physical_fault_addr, flags);
 			p += err_info->length;
 			continue;
 		}
@@ -671,13 +671,13 @@ static bool ghes_do_proc(struct ghes *ghes,
 			ghes_edac_report_mem_error(sev, mem_err);
 
 			arch_apei_report_mem_error(sev, mem_err);
-			queued = ghes_handle_memory_failure(gdata, sev, sync);
+			queued |= ghes_handle_memory_failure(gdata, sev, sync);
 		}
 		else if (guid_equal(sec_type, &CPER_SEC_PCIE)) {
 			ghes_handle_aer(gdata);
 		}
 		else if (guid_equal(sec_type, &CPER_SEC_PROC_ARM)) {
-			queued = ghes_handle_arm_hw_error(gdata, sev, sync);
+			queued |= ghes_handle_arm_hw_error(gdata, sev, sync);
 		} else {
 			void *err = acpi_hest_get_payload(gdata);
 
-- 
2.53.0



