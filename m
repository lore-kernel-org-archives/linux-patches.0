Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8260361657;
	Thu, 20 Aug 2026 16:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243218; cv=none; b=Ug3w25B5aZZdN68XCn1LOKa/x2XKZfJ56GsytltK7wv7tCgImfCvyxjdEsif5XuQyZ+sOMUATWer6aVmWyQ5uuMGAfSpH3qG0wd0u6zPqyoaQml+uxb38SQVv1LGDdnMcZwQIsHXIJkcj3yhZTgwA0UGJwY+Lerk/WKRntss9tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243218; c=relaxed/simple;
	bh=8TzPcP7MsGW+W+yJUaR9NRZGxA9ksy0974gxnyxW7oY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=saaQSIpZVDqXjLKp+9DwDdZArxR48y4rdSTKT10S+l6uWm67p/EdrVwsz7+o9rM5pqmgNxKtwsvGXz+E5ym/Gwz3mKUj3kOl5+pDP92KOr7h519Bz6R7NKPDZGQTbkMIUpS8oOlBI1syJAhHnRSg08Guz0o2MgkcogNaGtnfscQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mLxTAWW2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mLxTAWW2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117BE1F00A3A;
	Thu, 20 Aug 2026 16:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243217;
	bh=0sLZdtRgz1TtD63R7ljt7gVAHoZp+95KKvQANNx+cys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mLxTAWW2tNtWPA/GlBD6u7IfEmd+AqEvwM8rRUhT24jOJ6GX+DnPy96CSw3XJpjzT
	 OOjsI4cj2+UAON1y9z0XPlbHyq2Iu3JeVNAqg01XeC5CJJcOaQofR7c3VYSfs4j1bI
	 Fs/0gXIvuV3iQLyTmVlCB5IHk4/60/z2sdvRn5tU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nayna Jain <nayna@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	George Wilson <gcwilson@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 5.15 019/272] powerpc/pseries: lparcfg - fix kbuf[] underflow
Date: Thu, 20 Aug 2026 16:53:23 +0200
Message-ID: <20260820145231.810535499@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -641,7 +641,7 @@ static ssize_t lparcfg_write(struct file
 	if (!firmware_has_feature(FW_FEATURE_SPLPAR))
 		return -EINVAL;
 
-	if (count > sizeof(kbuf))
+	if (count == 0 || count > sizeof(kbuf))
 		return -EINVAL;
 
 	if (copy_from_user(kbuf, buf, count))


