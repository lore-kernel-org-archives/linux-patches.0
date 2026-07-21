Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF599470134;
	Tue, 21 Jul 2026 18:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658807; cv=none; b=T/sv7xoQw2io8QbjnvYHX7RkcGA2C4vB83y2MivWKITnr6nXMggM5aB1PMgFYN+hZ8azxWUeHhT4jCtKMqxrlgL2fZlKlfWWo2I3lx3IdKG227y5+PbmiVKz4lZAiUZDu9PS4exjiVZqOzzBotADsOnqKQGvLvbSIYEgeHtfmIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658807; c=relaxed/simple;
	bh=X9nOWkinagFEBJTc0MQk7sgvhmvIlO189PzIjUXv1V8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mGG+Mvm/A27kK/PlisrdeybE5foDejTu1AuswXzIfBSLnHvupjQSvrrz/Fhp/v6uajAzyIvVvMDkcq1S+vENJBv4GbDa3yHgOnbMPqz6EflYtxDMHvRPEKgxPhp0NDVIyd97OP6Dv4vHGs9PV3uRjRiEAUvEUa4qaD+fPmxXx7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KonJOXEa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KonJOXEa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DB41F000E9;
	Tue, 21 Jul 2026 18:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658806;
	bh=9MnxkOCp+NWpJCtyxF1XQty1yGajO2nqNNgNvLEVlZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KonJOXEaVMbiGSS7hmjOzucQS8Ut9kWdK8DNAk7sBvPQ64HWOREowpnCHPI7lmqiG
	 TlGphhbK+PwyDWm/geJYnpW10JERkeC9OaAM+w3t7aybKu+zTmKXzZhZ3oOXNUZAoh
	 uvuXNmWpS7bnJOfTu9pMEl4yEy561dTUdJ06C5dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 6.18 1282/1611] s390/pkey: Check length in pkey_pckmo handler implementation
Date: Tue, 21 Jul 2026 17:23:18 +0200
Message-ID: <20260721152544.281924847@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Holger Dengler <dengler@linux.ibm.com>

commit 1ac287e2af9a9112fe271427ef45eceb26bce8b4 upstream.

Explicitly check the length of the target buffer in the pkey_pckmo
implementation of the key_to_protkey() handler function. The handler
function fails, if the generated output data exceeds the length of the
provided target buffer.

Cc: stable@vger.kernel.org
Fixes: 8fcc231ce3be ("s390/pkey: Introduce pkey base with handler registry and handler modules")
Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/crypto/pkey_pckmo.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/s390/crypto/pkey_pckmo.c
+++ b/drivers/s390/crypto/pkey_pckmo.c
@@ -257,6 +257,10 @@ static int pckmo_key2protkey(const u8 *k
 				goto out;
 			break;
 		}
+		if (t->len > *protkeylen) {
+			rc = -EINVAL;
+			goto out;
+		}
 		memcpy(protkey, t->protkey, t->len);
 		*protkeylen = t->len;
 		*protkeytype = t->keytype;


