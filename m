Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC7F415F04;
	Tue, 21 Jul 2026 20:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664329; cv=none; b=JpRFAVx2DSlhtfqu8dHnYTgkhgcsuNUrC9lDqtL/GK85VF8H35NF2QBw23n5rIpcXahvAYwmASQlQyDAQQtp3HIlmiz1LNTQxMhWgLhPTOlY8JKRtfOFF4tJ4ByDvu5EktCc3WdZiXg6HhEqSDYamVg871+7SZ9NukBziF+8m5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664329; c=relaxed/simple;
	bh=y+ZBwqD46dvDuWg6Arp0TmVE95EvbIhjZgZrY/BAmIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oq/8InQGGH69/rvsrOsAPhKzZMegIukfjm/pQta6/dQygPFoZxCwaS4zwZupqnJqNdMDtTuAmc6qMRRX0XVJRebvhZ1NheHi0dNHDh39OIUcFKmnCGhpGAGUzaGxGhbTvggIvgI5oh9+zsW5lmlNK4jsgiWYjAZMM4ltM7/jBX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zp7PMtwN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zp7PMtwN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BAD81F000E9;
	Tue, 21 Jul 2026 20:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664328;
	bh=rxGRG5PqBhkO2O/WkJQ9LftqUkVrQ1BnTt7SX8coPyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zp7PMtwNCge4xyb3kjZZAptrgiFSp1Da+IV1sAtDV3JLLFp4pj2ya7oQqA+43Ky2u
	 MF7BI6KISArWmY9uIExMXMdt0Y2IR5JBAeOj5UQyT09wEmyVn9k39DolrKtm2/NJVN
	 vmMrgBO01gDEHHky3oYDBPTVBLC+bIK1bU6e7sOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.12 1106/1276] powerpc/pseries: fix memory leak on krealloc failure in papr_init
Date: Tue, 21 Jul 2026 17:25:49 +0200
Message-ID: <20260721152510.740544602@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

commit bd83c98b988d2c560531084e296dbfb530aff829 upstream.

When krealloc() fails, free the original esi_buf before returning to
avoid a memory leak.

Fixes: 3c14b73454cf ("powerpc/pseries: Interface to represent PAPR firmware attributes")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260614142356.658212-2-thorsten.blum@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/papr_platform_attributes.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/arch/powerpc/platforms/pseries/papr_platform_attributes.c
+++ b/arch/powerpc/platforms/pseries/papr_platform_attributes.c
@@ -271,11 +271,9 @@ retry:
 		esi_buf_size = ESI_HDR_SIZE + (CURR_MAX_ESI_ATTRS * max_esi_attrs);
 
 		temp_esi_buf = krealloc(esi_buf, esi_buf_size, GFP_KERNEL);
-		if (temp_esi_buf)
-			esi_buf = temp_esi_buf;
-		else
-			return -ENOMEM;
-
+		if (!temp_esi_buf)
+			goto out_free_esi_buf;
+		esi_buf = temp_esi_buf;
 		goto retry;
 	}
 


