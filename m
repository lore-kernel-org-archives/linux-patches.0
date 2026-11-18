Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054216;
	b=RTeV4JobtGPvJ+GmUw4KiOL0vkTZLQLuejcRDo3o2KwCF4U27QU5dVreyswCvtEEPH8m
	 Znrl6C72CI/fbPWo6fxct/sRgTk1E887NXkur8zWGgv6dzXq4vlyfe2i5E9cvu2LA6+Ki
	 GvRQ4FyQdSWlsPQEtmGeD8ffG+oGvkk9waNzo1z6CjJ6ZKAH5D+44JPks/9LG6GZ3V2Ix
	 ChdL+e6KM0+3bK+68Kiax7OucM0zJVWpejZxmiB4b50bj9d6T7iejVrWjZlwxaeTq0nrc
	 NnHIF+LDPAcQXO4pJ4QYITfmL+a+52Q6uBeZanhxwb+ex8FYX/dAT2PrWzn3SowERzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054216;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KwcfypOIwhZqR9KlsyXgMJZJakc6h+Ls+VazU/wWKZE=;
	b=pl4SmAj4tPgX78bL/9ns/Pcu9xgCIRAivFuq8I0D8k3cah/htQBID5pGA5/d8Ge5JQ4g
	 KcLYN5Lyhq43ShfP+iG05TE33YQxB68VCmqzZpq0pia6yf8E1NzAxODsJ5W/XKahq7I4C
	 8nkYUpHIm1wey+PdGm6uBDM5E6mYBCr6701BffoLP3eN4MWWMijuLKasdlgqtrIx2nA/L
	 9pldY9XMwz+57iYocYxN+Hh6qmPNnDwJn3OzO3Xl8tuNx3g2uBS8O2yqrmHB2aQEyJIri
	 Gx32W7SAU/c5cDI7vb4J/M23vRDY8aCqD5jQt1ldIryfamky/+lR/UopwUtBWUiuqDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PvsInWRD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1375606A325;
	Thu, 19 Nov 2026 02:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PvsInWRD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250301F000C6;
	Thu, 19 Nov 2026 02:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054216;
	bh=KwcfypOIwhZqR9KlsyXgMJZJakc6h+Ls+VazU/wWKZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PvsInWRD32ZsD3t3lSO7pPDdmunTlL5roa4WI6qtvY1+r2P1m+5I9CFKvhWg6JcIo
	 b5hJAUUFatLZWonh7bxm/FtORu8qsomIHb1TTbl11buRjF69n67pnlNnQM/l76wj82
	 8gTtB3E7lG/n6fKTriNNGrOfH9Bb35u1AGJSAcg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1159/2214] ACPI: APEI: accumulate the queued flag across error sections
Date: Wed, 18 Nov 2026 15:47:15 +0100
Message-ID: <20261118150058.407106285@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
[ sashal: adjusted context to match the older ghes_do_proc() error-section handling layout ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/apei/ghes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 88c01d4a7f8fa..29cece11ccb22 100644
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



