Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F297389473;
	Thu, 20 Aug 2026 17:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247970; cv=none; b=as+c/BOGGJmNVbHGKwoOx8Gp1gSMErwfMsXLFnx9knT7ap0WbWCZ4xXin33ZxtQWwnXSZ3KycgXjCUeulbktftVhj2+zyAXshlXCXjac29SCp1uOm07T5YaVTxsFI0rsjMBerU2vtZ4k+OR9/wYlOVwfGjt8iACgQ7D+GoTXB3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247970; c=relaxed/simple;
	bh=SKFWmyKtpXOqkmeaLFc/47gcF/z7cgzN5sog15iUz1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eeUigBy9asI6WPpLTTeML0GKaBe2NIwuITesreCFD6+LjxeKNx25/SJD5JnxNlMCT3To0UiI03EBNiwL5FlSU33fqKmpRxLFGYnZO+fxIODAvf2kVG1YcFvyEC1WYtI9Zk02kz+w8QgtUbIXEYlkvA4P9SoLU4jw1A1646Vg0AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v63I/Sra; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v63I/Sra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336901F00A3A;
	Thu, 20 Aug 2026 17:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247968;
	bh=yIecoVWrFRtxu78X0exM7W31jtXsjFsrvWq++rYMHkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v63I/Sraqv7K0yN8YIQeIDhCkHK8Kwch84WhRuOuPrEA/R+D3soWECO2N2A8XUfsE
	 vTIAFvwRDo2pIAwiWfYsqNucB6P9lqbhb4DSOrb+7JCvZzB1ZNxCIeGP9lQ3uxnO2C
	 1MT6w2/+yE/cjSmHeQcxpxqXLxwi+MHWRRmQ8EnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nayna Jain <nayna@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	George Wilson <gcwilson@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.1 025/303] powerpc/pseries: lparcfg - fix kbuf[] underflow
Date: Thu, 20 Aug 2026 16:52:41 +0200
Message-ID: <20260820145253.937722821@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Wilson <gcwilson@linux.ibm.com>

commit fb442a6673ff1046bf67754957d95880fdb394b5 upstream.

In lparcfg_write(), a count of 0 results in kbuf[] being indexed at -1.
Check for count == 0 in the existing check for count > sizeof(kbuf) and
return -EINVAL if true.

Fixes: 74422e2b1939 ("powerpc/pseries: Remove VLA from lparcfg_write()")
Acked-by: Nayna Jain <nayna@linux.ibm.com>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>
Cc: stable@vger.kernel.org # 4.20
Signed-off-by: George Wilson <gcwilson@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/lparcfg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/platforms/pseries/lparcfg.c
+++ b/arch/powerpc/platforms/pseries/lparcfg.c
@@ -729,7 +729,7 @@ static ssize_t lparcfg_write(struct file
 	if (!firmware_has_feature(FW_FEATURE_SPLPAR))
 		return -EINVAL;
 
-	if (count > sizeof(kbuf))
+	if (count == 0 || count > sizeof(kbuf))
 		return -EINVAL;
 
 	if (copy_from_user(kbuf, buf, count))


