Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34E5221562;
	Thu, 13 Feb 2025 14:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457951; cv=none; b=OZe5/7nM7T8pia3vDsqKuhUDy0EaCzkZ0p8kc5l9b/fmaJXNCR2yuyanz2vOFjJT4Ru20Jwgl74StD4itsdf2RihK33d8oeDgsjo6jNzoCDZwIFYyjQWxPGvHQyOp1he70oIT/gxdPOWfBiZWkt9/4eoZTN5WhjnGc1ZSywuF+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457951; c=relaxed/simple;
	bh=PsRT0QQL5WqgXrCh1YETQtvgx97eZ2NiBant6P7QukQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EqHeSDocYI9jB1usykyxlQLftslsk8syzyJm2NGVo8eUpHaHrHTIoPyv128PY3HK+ERo6YKypQponGFUZF0mvLSa19l7wu5QlRgkv8BxrwKDTkzQmMOyIUBbZLid7JOf76MsakPyIp40Yqpqf05LJf3+k76dk7aptyw58gPVD2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wZFhqWpK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wZFhqWpK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00474C4CED1;
	Thu, 13 Feb 2025 14:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457950;
	bh=PsRT0QQL5WqgXrCh1YETQtvgx97eZ2NiBant6P7QukQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wZFhqWpK+i21tOjMhbj0+Lgh4KC01vl1NYeLNGYCL5br48OrtZGgjI6ubAaJmacBs
	 kq2i5stD9pUED8I9Sm5ariSIDHgxdf/t39S95BNKI/w9B2yFIgvJCJcUChHBFWopR9
	 sb5cdHhpDACMN4rwEBZ4sd9b8xz3CTX/QaUw+KLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Pylypiv <ipylypiv@google.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 259/422] scsi: core: Do not retry I/Os during depopulation
Date: Thu, 13 Feb 2025 15:26:48 +0100
Message-ID: <20250213142446.534025980@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -865,13 +865,18 @@ static void scsi_io_completion_action(st
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


