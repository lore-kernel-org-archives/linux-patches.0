Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8BF442B39;
	Thu, 20 Aug 2026 16:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244114; cv=none; b=CziUWqFXbRJA4pwyqsUHG9xRpw/qTYnz4qN2OnlVCTe+pL3vIVWjIIAPHtX4vphn3fHdWleC54hHcSnFGADcifyI9V96gJsx7f/gxx3hQ6Y5V6qVdyYg86BWmf+14XHLs8IFvH9ba/OZfimKj9Qn1q5mwkbekEN7LErjdYyveqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244114; c=relaxed/simple;
	bh=jOg0WgyBnvhqIlqi2FcS8Ij3S+VXaA0jzb8ug/lUoQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IAHozemW9CI0N9w4UqyGCB3Kv8QNc85VQTWd4yKXYc26FVs814sOe/Ofdv0/spOJxyMsPPR/+nCjIRA2JKQ4Elmerz8H8h1yNCyuhuNYeBp7iEc1BDymrmbYNsr1eWkaHQniZAxJL9uIBVYgv9rmFW1SR9N56V1Ncdm/KyzlpPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mKwQzd63; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mKwQzd63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262DB1F000E9;
	Thu, 20 Aug 2026 16:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244113;
	bh=ex5B/jIbJ3ShZ/mNaZjhZnQBXC1EfVbsg415g6NyTqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mKwQzd63qkOaBIylTFczolUcRDlXyqH3WSa14hgGkrjxhYhTtHWaVdt/RI01OLYcn
	 iHjo/HOu5N6LZngm8pHym5I8NMgZIZKaIKi5/fztqbHlraIaFsRX16gIk5GaHCiMB/
	 2RkqKmwXTNxl0r6qPAlAzwtC9GLEs6feTnrGJVR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nayna Jain <nayna@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	George Wilson <gcwilson@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 5.10 016/235] powerpc/pseries: lparcfg - fix kbuf[] underflow
Date: Thu, 20 Aug 2026 16:54:12 +0200
Message-ID: <20260820145216.933044278@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -639,7 +639,7 @@ static ssize_t lparcfg_write(struct file
 	if (!firmware_has_feature(FW_FEATURE_SPLPAR))
 		return -EINVAL;
 
-	if (count > sizeof(kbuf))
+	if (count == 0 || count > sizeof(kbuf))
 		return -EINVAL;
 
 	if (copy_from_user(kbuf, buf, count))


