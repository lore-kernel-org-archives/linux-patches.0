Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B894E48786;
	Sat,  3 Feb 2024 04:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933733; cv=none; b=MIg45G0eyaDD5AT9Va8ZHZCn19ViOQnGpo4YQkn5uzgb+btdxXoVl2aOXmJmFr64T6psCFjzt1CMlxaROkeI3QuMhg+i/WmF2E9E2DMtz8zpcZEG+H7/SiQCr4hMkrjhcpV6Zhd9bfjPnEnrJdrBS+oLZ5XTLkfRKQSFruVOSvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933733; c=relaxed/simple;
	bh=RjD9MTeZdwid756Ahi882o8sfCdm7zKjVdYpKGgdnVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SnZcAnaFjQtk05pWdPPCYCGPsE2qKONAX5yU62hQ8a2uHySWbWir0FNOlB+1Vhjxlx72UMf06HcD5izpGZlsIAt7TTrdPW5cKJxdRKEJPIXPBLancNro5GN6BFALssg0w5npoxv05Rx5RQPXINgTT33ylZFPkbfS336Ofhtbe4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dcwIZHb4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dcwIZHb4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80132C433F1;
	Sat,  3 Feb 2024 04:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933733;
	bh=RjD9MTeZdwid756Ahi882o8sfCdm7zKjVdYpKGgdnVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dcwIZHb4PE1TWnz9wuy+tqXohfk/nLfrU2c06NbDmQb358tCIXjUDWUDgH4sb38y7
	 XQNrc5Gr763UKcyZ/PFOYtneT9VRYVh39z5gqB1Gpg2OAQ4dWVGgtpoMDAUe1ncMc2
	 a2fPPs42rxWhK5WN16I/B92yOJHFsyE1tK9Phe8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prarit Bhargava <prarit@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 021/353] ACPI: extlog: fix NULL pointer dereference check
Date: Fri,  2 Feb 2024 20:02:19 -0800
Message-ID: <20240203035404.413037823@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prarit Bhargava <prarit@redhat.com>

[ Upstream commit 72d9b9747e78979510e9aafdd32eb99c7aa30dd1 ]

The gcc plugin -fanalyzer [1] tries to detect various
patterns of incorrect behaviour.  The tool reports:

drivers/acpi/acpi_extlog.c: In function ‘extlog_exit’:
drivers/acpi/acpi_extlog.c:307:12: warning: check of ‘extlog_l1_addr’ for NULL after already dereferencing it [-Wanalyzer-deref-before-check]
    |
    |  306 |         ((struct extlog_l1_head *)extlog_l1_addr)->flags &= ~FLAG_OS_OPTIN;
    |      |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~
    |      |                                                  |
    |      |                                                  (1) pointer ‘extlog_l1_addr’ is dereferenced here
    |  307 |         if (extlog_l1_addr)
    |      |            ~
    |      |            |
    |      |            (2) pointer ‘extlog_l1_addr’ is checked for NULL here but it was already dereferenced at (1)
    |

Fix the NULL pointer dereference check in extlog_exit().

Link: https://gcc.gnu.org/onlinedocs/gcc-10.1.0/gcc/Static-Analyzer-Options.html # [1]

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_extlog.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/acpi_extlog.c b/drivers/acpi/acpi_extlog.c
index 71e8d4e7a36c..ca87a0939135 100644
--- a/drivers/acpi/acpi_extlog.c
+++ b/drivers/acpi/acpi_extlog.c
@@ -308,9 +308,10 @@ static int __init extlog_init(void)
 static void __exit extlog_exit(void)
 {
 	mce_unregister_decode_chain(&extlog_mce_dec);
-	((struct extlog_l1_head *)extlog_l1_addr)->flags &= ~FLAG_OS_OPTIN;
-	if (extlog_l1_addr)
+	if (extlog_l1_addr) {
+		((struct extlog_l1_head *)extlog_l1_addr)->flags &= ~FLAG_OS_OPTIN;
 		acpi_os_unmap_iomem(extlog_l1_addr, l1_size);
+	}
 	if (elog_addr)
 		acpi_os_unmap_iomem(elog_addr, elog_size);
 	release_mem_region(elog_base, elog_size);
-- 
2.43.0



