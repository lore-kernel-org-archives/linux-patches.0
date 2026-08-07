Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13F4381AE4;
	Fri,  7 Aug 2026 15:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115438; cv=none; b=EZ/X5zYE2gx6hL4RGq66nmfq3i3OSczzGVcEzeV2zVagnAcuATWM5rMbEnR8DxxJG4CsgwD6+u+ZY/WwKezbptw9VILrhiLZq5h4vyUNa2UwnaoAceqdJpgjXBYed0Dk4PKFWz/NBT0+YqvPODnXygP3DQYQxftVBHYDQ1IxH6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115438; c=relaxed/simple;
	bh=GogxRZnNcm4sO07UMqX6yuUTyodE06/nIY0w8LHlmVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CaM9jIuoc48gRY68sBPXQDKWhkRgASV0+eYF10w0J7NtDH8nD1ggZYYxGXCeGTXShjNTTi67IucMnmmc8vqGkX8mNq5T0WSZuVCVCUdwlutM9D1ReUI0idI4VLjHbN+CI9pmQNGtOIeo3y08xznaDqnnyuCzNvZTwaoD5j5vT4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iHjNUwB4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iHjNUwB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7CA01F000E9;
	Fri,  7 Aug 2026 15:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115436;
	bh=o1ANWu0HtYYC1YpchZ2qxBpDVg+pUjOumGI2Y8g4Y18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iHjNUwB4M3fRIUAnr22myULYPKDLrl7LruMsmeC0VO2DoWy/akjysNrL7IudP3UeI
	 o6z1XyAgQrvThHXt2UiBIOE4teIPJ6Esdek9SsHBf0HQcPds5iIJLYpPYF8v7onG1Z
	 /IiVyb6RTdlXohjliUWqPkx7s2WHBWepWyseHcJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Callies <fcallies@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.18 274/396] s390/zcrypt: Fix wrong domain value verification with EP11 CPRBs
Date: Fri,  7 Aug 2026 16:37:14 +0200
Message-ID: <20260807143430.169099316@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harald Freudenberger <freude@linux.ibm.com>

commit 983279d7f86ade73db86f886e09172dd567031b5 upstream.

There is a wrong upper limit check for the domain value when an EP11
CPRB is processed for sending to a crypto card. This check is only
active on custom device nodes but may lead to access heap memory
behind perms->adm when an administrative CPRB is sent.
Add correct limit (AP_DOMAINS = 256) checking to fix this.

Fixes: cfd68b33094e ("s390/zcrypt: Filter admin CPRBs on custom devices")
Cc: stable@vger.kernel.org
Reviewed-by: Finn Callies <fcallies@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/zcrypt_api.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/s390/crypto/zcrypt_api.c
+++ b/drivers/s390/crypto/zcrypt_api.c
@@ -1083,7 +1083,7 @@ static long _zcrypt_send_ep11_cprb(u32 x
 	print_hex_dump_debug("ep11req: ", DUMP_PREFIX_ADDRESS, 16, 1,
 			     ap_msg.msg, ap_msg.len, false);
 
-	if (perms != &ap_perms && domain < AUTOSEL_DOM) {
+	if (perms != &ap_perms && domain < AP_DOMAINS) {
 		if (ap_msg.flags & AP_MSG_FLAG_ADMIN) {
 			if (!test_bit_inv(domain, perms->adm)) {
 				rc = -ENODEV;


