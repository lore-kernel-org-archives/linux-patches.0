Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82DD26B0A5;
	Thu, 13 Feb 2025 15:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459503; cv=none; b=b8oX/C6TDuPoyBsn6BnG8VI4dufNyam6xN5jdJVmCxN5yP3YqVj+Anm3RAM8k9sf0G6TJfcU/hQd9KzkoE3ZYRAfIUABWwJrmE9tkWD35r7an2ufsBl/FFgvxRypRMvL2hRsNF/xjVgIXFAd+CGMOIxGrAiDhhFNeTUUieFcdGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459503; c=relaxed/simple;
	bh=oeolEs5zXhZbzNEdTT1QscT+K9zORJ6WcRXlFtKWRwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZP9EmO/7bw+yOxb/T79CPlOUkfcRaB42ak1/5S86EyNrzwppwAprTEJFSc6GXsWZct7qyZXCLbBI3knPed8rl0CCDOdTP8K4133yrnvm+ihb+/gO8YI2szX++l+o8CAc/PKjR2uNiaYfQsJXQNEZPHJot/qffBJ+388MUhsJSYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YtRH2JfD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YtRH2JfD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4026EC4CEE4;
	Thu, 13 Feb 2025 15:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459503;
	bh=oeolEs5zXhZbzNEdTT1QscT+K9zORJ6WcRXlFtKWRwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YtRH2JfDtXviaqLTLuL3VQqjlIiT6w7hsxlM5JEfk7FE4fQkyXgaFZ+vchYA6WDci
	 W22WKXkz496zBjAPbZD+sD7ufIuYar31AY0VKtayO4RBQDFSDY5YG/7k8HQ+5gAGtN
	 DVmg2fZVxPMxoPoTMyxTkHYwgphf04V5lsKUODwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Pylypiv <ipylypiv@google.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.13 285/443] scsi: core: Do not retry I/Os during depopulation
Date: Thu, 13 Feb 2025 15:27:30 +0100
Message-ID: <20250213142451.610318752@linuxfoundation.org>
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

From: Igor Pylypiv <ipylypiv@google.com>

commit 9ff7c383b8ac0c482a1da7989f703406d78445c6 upstream.

Fail I/Os instead of retry to prevent user space processes from being
blocked on the I/O completion for several minutes.

Retrying I/Os during "depopulation in progress" or "depopulation restore in
progress" results in a continuous retry loop until the depopulation
completes or until the I/O retry loop is aborted due to a timeout by the
scsi_cmd_runtime_exceeced().

Depopulation is slow and can take 24+ hours to complete on 20+ TB HDDs.
Most I/Os in the depopulation retry loop end up taking several minutes
before returning the failure to user space.

Cc: stable@vger.kernel.org # 4.18.x: 2bbeb8d scsi: core: Handle depopulation and restoration in progress
Cc: stable@vger.kernel.org # 4.18.x
Fixes: e37c7d9a0341 ("scsi: core: sanitize++ in progress")
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Link: https://lore.kernel.org/r/20250131184408.859579-1-ipylypiv@google.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_lib.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -868,13 +868,18 @@ static void scsi_io_completion_action(st
 				case 0x1a: /* start stop unit in progress */
 				case 0x1b: /* sanitize in progress */
 				case 0x1d: /* configuration in progress */
-				case 0x24: /* depopulation in progress */
-				case 0x25: /* depopulation restore in progress */
 					action = ACTION_DELAYED_RETRY;
 					break;
 				case 0x0a: /* ALUA state transition */
 					action = ACTION_DELAYED_REPREP;
 					break;
+				/*
+				 * Depopulation might take many hours,
+				 * thus it is not worthwhile to retry.
+				 */
+				case 0x24: /* depopulation in progress */
+				case 0x25: /* depopulation restore in progress */
+					fallthrough;
 				default:
 					action = ACTION_FAIL;
 					break;


