Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F922F1FED;
	Thu, 12 Mar 2026 20:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347365; cv=none; b=d/BL9zFh3hNLqB3lntsPHvoMQ0Lf1BTOsX2qDPqgJ7VrnkZ7JOLyyILqWgUC/vIQ+aEfG4uG+UlIxvI6hbhhLTMqF/0/jmAghM+J5LEnwdctQByL/XLvaTGD5+rWnRvqLePzTD2E3/OGsqV7+7yWI39dLVsExNR7HMoCwPRNSQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347365; c=relaxed/simple;
	bh=DBG/SHQheft6cdInUX0G1Kwn1ZZ+LUsea/+iJilPi6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/7v11ZLaQRDhKHXcoPVujjLz+O563rHWbrWkRApFyt42CNLH1J+97bWIGfeKBeeQ/e7WylGQRIjq1kgMZz9TQsbiN43ODjJBJjUn4rv6m/+L4hqEvzchtVnj5chHkFPV9K7XnG0bYOfGGuwwZzUNeg3dyHHl0eDrMgTOZvIXQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bd7LjOXp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bd7LjOXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD30BC4CEF7;
	Thu, 12 Mar 2026 20:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347364;
	bh=DBG/SHQheft6cdInUX0G1Kwn1ZZ+LUsea/+iJilPi6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bd7LjOXpi2sNTAsqC6ec8UolrLHWq1Fw5Vv+iAemoYG9LxUE7WmXvHR2h7aXvFEc/
	 f+2uz1JzkHq5KM5qSCOgLhgEFUpVlOsoynX8elZ/brnQ1QsPM65Du49KbqmWW8GpkM
	 wmj9imIPZdKGryk43AK4NsGbWQOkRKzQ0hAzeTnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.12 265/265] ata: libata-eh: Fix detection of deferred qc timeouts
Date: Thu, 12 Mar 2026 21:10:52 +0100
Message-ID: <20260312201027.926794851@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit ee0e6e69a772d601e152e5368a1da25d656122a8 upstream.

If the ata_qc_for_each_raw() loop finishes without finding a matching SCSI
command for any QC, the variable qc will hold a pointer to the last element
examined, which has the tag i == ATA_MAX_QUEUE - 1. This qc can match the
port deferred QC (ap->deferred_qc).

If that happens, the condition qc == ap->deferred_qc evaluates to true
despite the loop not breaking with a match on the SCSI command for this QC.
In that case, the error handler mistakenly intercepts a command that has
not been issued yet and that has not timed out, and thus erroneously
returning a timeout error.

Fix the problem by checking for i < ATA_MAX_QUEUE in addition to
qc == ap->deferred_qc.

The problem was found by an experimental code review agent based on
gemini-3.1-pro while reviewing backports into v6.18.y.

Assisted-by: Gemini:gemini-3.1-pro
Fixes: eddb98ad9364 ("ata: libata-eh: correctly handle deferred qc timeouts")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
[cassel: modified commit log as suggested by Damien]
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-eh.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -649,7 +649,7 @@ void ata_scsi_cmd_error_handler(struct S
 				break;
 		}
 
-		if (qc == ap->deferred_qc) {
+		if (i < ATA_MAX_QUEUE && qc == ap->deferred_qc) {
 			/*
 			 * This is a deferred command that timed out while
 			 * waiting for the command queue to drain. Since the qc


