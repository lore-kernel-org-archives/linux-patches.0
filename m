Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32981465B1;
	Thu, 13 Jun 2024 12:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280254; cv=none; b=J5/SY3B0xDjMFeyW4xJvPu/mkGrdyOUbmV+wITJpCZpiea5UqSJv7NCrTOWlIDicJCRYwk0gXAm2CdGjRgUsoctbmoXN+eV122a/5qJcAFvJ6aIsljABCpioSZuwgsccvHbcnLWHzgDvkp/+7d/qXX8Adqqp3fGwZqfzMchTWF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280254; c=relaxed/simple;
	bh=+xl+z762ZG8yw2HWXnVMBVdS1/iCtm6UAtdPQZraYeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=af+/+ajf5cm2iR+Z+uFiL/ZW3f5ue/CWQBj2S/oE5f4jIXVxwjq3vtkQvLhxO50jCAYfgJjrADlvZJ//ifngKiteauFAJZObPMVa+owlEG1zXtiFGnbqkRz5D6KLF8K/UozLSq0oQvtkjdMo76zohEsiJyzK1+7EW+3vthkkYLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eo+1pFWv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eo+1pFWv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7EEC32786;
	Thu, 13 Jun 2024 12:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280254;
	bh=+xl+z762ZG8yw2HWXnVMBVdS1/iCtm6UAtdPQZraYeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eo+1pFWvOpUNLuRzEmWbH4Fc3Y/wjRiSTkfbyRl5yakOrv5EnpjnPKs6SM+PnYOwp
	 UOysVRVkAtaHZ6m2f7+2znopilOIL3m+nrF3kb37Mu9jACwcZ9Deln+bEzvvWgfo3J
	 rNwCkb4bkM6qryVzrOtLlwVDqYL22BpxGIMVQLc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Justin Stitt <justinstitt@google.com>,
	Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH 5.4 195/202] kdb: Merge identical case statements in kdb_read()
Date: Thu, 13 Jun 2024 13:34:53 +0200
Message-ID: <20240613113235.265726813@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

From: Daniel Thompson <daniel.thompson@linaro.org>

commit 6244917f377bf64719551b58592a02a0336a7439 upstream.

The code that handles case 14 (down) and case 16 (up) has been copy and
pasted despite being byte-for-byte identical. Combine them.

Cc: stable@vger.kernel.org # Not a bug fix but it is needed for later bug fixes
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Justin Stitt <justinstitt@google.com>
Link: https://lore.kernel.org/r/20240424-kgdb_read_refactor-v3-4-f236dbe9828d@linaro.org
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/debug/kdb/kdb_io.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -314,6 +314,7 @@ poll_again:
 		}
 		break;
 	case 14: /* Down */
+	case 16: /* Up */
 		memset(tmpbuffer, ' ',
 		       strlen(kdb_prompt_str) + (lastchar-buffer));
 		*(tmpbuffer+strlen(kdb_prompt_str) +
@@ -328,15 +329,6 @@ poll_again:
 			++cp;
 		}
 		break;
-	case 16: /* Up */
-		memset(tmpbuffer, ' ',
-		       strlen(kdb_prompt_str) + (lastchar-buffer));
-		*(tmpbuffer+strlen(kdb_prompt_str) +
-		  (lastchar-buffer)) = '\0';
-		kdb_printf("\r%s\r", tmpbuffer);
-		*lastchar = (char)key;
-		*(lastchar+1) = '\0';
-		return lastchar;
 	case 9: /* Tab */
 		if (tab < 2)
 			++tab;


