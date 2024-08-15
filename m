Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C540C1B29C1;
	Thu, 15 Aug 2024 14:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731157; cv=none; b=aDV6I99CKMSsXXxEneEcKFtzNA7+wbsN2zfu9Ujs33x1K/ZnI3+gE3mV/OceJZ3wEG34hRb7IiqRSLlIfRU5l4n/bhA6xMfnKUrLbKjl3wO7AFqQYntMkSoGehHrwAntrtPJwx+z/g6AmRnegFxBUWSHl4cPGzJPhqPArzoDDYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731157; c=relaxed/simple;
	bh=oOgy9uWBGcogmGnZJdG/omrM7A+W7xNM1fgon1LKar4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P1qGeeRNxFXAmHd3dmCRQLNc1b6VyXJHvxcEpaVSPMzYP02zrcpgP/BonIgFWHS2E5TCWByyebNISlqGaVIj6MUGuc4uUp15+Yz43gOc5sJmQrwA/nzojP3ge60Ioeon+UY+n2BLHIm7tmgLrGnaTLWS7EfeWSSigrImH6T1mcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bsFO8C7l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bsFO8C7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE234C4AF0D;
	Thu, 15 Aug 2024 14:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731157;
	bh=oOgy9uWBGcogmGnZJdG/omrM7A+W7xNM1fgon1LKar4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bsFO8C7lmoT89Jg13TN2nj18AFz6ZfpmV3KMA3cckBRQzEXIYzXvTViaXajx6KsVX
	 d1OuYAQ1VR+dVuEAHxEtu+TijkrCF9eIKetCr/+mJvk7ym3ULrV0k5+uzZzCW6zZzD
	 0GSVwNFvMS5ET/f8KheloN6BYqxuCGxEWfXDWLvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 041/259] perf/x86/intel/pt: Fix pt_topa_entry_for_page() address calculation
Date: Thu, 15 Aug 2024 15:22:54 +0200
Message-ID: <20240815131904.389865165@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 3520b251dcae2b4a27b95cd6f745c54fd658bda5 ]

Currently, perf allocates an array of page pointers which is limited in
size by MAX_PAGE_ORDER. That in turn limits the maximum Intel PT buffer
size to 2GiB. Should that limitation be lifted, the Intel PT driver can
support larger sizes, except for one calculation in
pt_topa_entry_for_page(), which is limited to 32-bits.

Fix pt_topa_entry_for_page() address calculation by adding a cast.

Fixes: 39152ee51b77 ("perf/x86/intel/pt: Get rid of reverse lookup table for ToPA")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240624201101.60186-4-adrian.hunter@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/pt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index f4d2322f4c629..10ccc30d84638 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -935,7 +935,7 @@ pt_topa_entry_for_page(struct pt_buffer *buf, unsigned int pg)
 	 * order allocations, there shouldn't be many of these.
 	 */
 	list_for_each_entry(topa, &buf->tables, list) {
-		if (topa->offset + topa->size > pg << PAGE_SHIFT)
+		if (topa->offset + topa->size > (unsigned long)pg << PAGE_SHIFT)
 			goto found;
 	}
 
-- 
2.43.0



