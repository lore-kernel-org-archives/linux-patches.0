Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590144;
	b=teBZnVHnZCxfimGOOXEYy2ElTSi8xYVueGnC31B/m6ZofDBOzBrx9/xqAzkmLePOfUlU
	 ci0e2VvE1iFsXWyodGzwIjqfERzbgMAEl7eNC1MCDHwYh7KLYH08riFQqXtlNnZ1rAgP8
	 xKOOz9uQzOK999Q4ruknW25zUsN3wX1BLAfHt+jX3TxQ3V0vPqDCM6P0VyN7nCNgUzev0
	 DM4bNHKTXAne68SGD4v4JW2fiw/ksD0kquZxLFvW+ILk6yIgf2Ge7w26JVzOqdH1P43Ed
	 3iKDEWa/RYaAg2uQiIDl9YjSkis5mSCDxQRWfN//0Mtm/gOLi1G5NUVX5Teo6PO00ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590144;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ti5FK5yzIWIPE8E9ORY5ba206pR6QKuDNNwdfYKiZmE=;
	b=Q3k6ksR7tA1WKrb/vKawf4xf2Hxl89oAQqWo711ha16+hLGc7PQwjxLiZ5+teHwuMJsu
	 Yn5O/qoH7bHoUMNy9VsnwAK+Ejs0+QEZDRPvG6K8X4tLLPRC08ytQOO7+2+76DBF9hRTh
	 LHG1kMmnaVvJpcr2JegJEWzQUAxL0RYjjoAx0U5EyHat9QZhUAWjDiscHT69I/2R+HixG
	 aWDvUT+WWlH6Kc0LYCjCegO98+aDWzNY6omSGw0btGNMtrxvqvCDaX8KPHbmiYnHTRu7B
	 OgzmPBkFFfYnSM74vdnzI9lNQcbaj1AqKjHy4Md3qXxpSEWsny1LHejx3LTkThB7gjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WsHkhs9d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A30A606D482;
	Fri, 13 Nov 2026 17:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WsHkhs9d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EC41F000C5;
	Fri, 13 Nov 2026 17:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590144;
	bh=Ti5FK5yzIWIPE8E9ORY5ba206pR6QKuDNNwdfYKiZmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WsHkhs9d/TCtCjNNrMfSf34KNWGRIKhpZZ2v7GwsHxIS4+L06FWcMKjMhnZK7xTI3
	 qIAXUwLbUaNLfmnQz3ymIug5snq3DCk0ctuOLgx3Zws2MqU/ph4Go8Z4D3gJlPSfBE
	 s18A8HD9dOBPHtsehgzRIewBILAUwZj3i18Y1ICM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 160/686] ACPI: APEI: accumulate the queued flag across error sections
Date: Fri, 13 Nov 2026 10:44:53 -0500
Message-ID: <20261113153826.208958166@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/apei/ghes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 1a77aba0475be..f301bee643318 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -608,7 +608,7 @@ static bool ghes_handle_arm_hw_error(struct acpi_hest_generic_data *gdata,
 		 * and don't filter out 'corrected' error here.
 		 */
 		if (is_cache && has_pa) {
-			queued = ghes_do_memory_failure(err_info->physical_fault_addr, flags);
+			queued |= ghes_do_memory_failure(err_info->physical_fault_addr, flags);
 			p += err_info->length;
 			continue;
 		}
@@ -925,11 +925,11 @@ static void ghes_do_proc(struct ghes *ghes,
 			atomic_notifier_call_chain(&ghes_report_chain, sev, mem_err);
 
 			arch_apei_report_mem_error(sev, mem_err);
-			queued = ghes_handle_memory_failure(gdata, sev, sync);
+			queued |= ghes_handle_memory_failure(gdata, sev, sync);
 		} else if (guid_equal(sec_type, &CPER_SEC_PCIE)) {
 			ghes_handle_aer(gdata);
 		} else if (guid_equal(sec_type, &CPER_SEC_PROC_ARM)) {
-			queued = ghes_handle_arm_hw_error(gdata, sev, sync);
+			queued |= ghes_handle_arm_hw_error(gdata, sev, sync);
 		} else if (guid_equal(sec_type, &CPER_SEC_CXL_PROT_ERR)) {
 			struct cxl_cper_sec_prot_err *prot_err = acpi_hest_get_payload(gdata);
 
-- 
2.53.0



