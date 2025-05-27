Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA1B139579;
	Tue, 27 May 2025 17:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365737; cv=none; b=J8Q3Tz9CdvrsQuFSgbjFPhwp90V/4apD/Zhx0tYAQ2o3BU265jC2pCk9WsyrHVe0VP24itifE7ygxRjeRra1wrl4QCwU2bIlDky9NxxE8d5HBX7WWNKcgzCl/KUuKpeVUpNQmEoEJVDVsUG2qWCveaDo1YZQb/W/107aabLb8+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365737; c=relaxed/simple;
	bh=GffCcDeN5XBFRCFFkCDhX5xgQ5fj+/HVT2n/YAKI2oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YrwqnOxKnv3RAjccSFKEMShAjTa4GEC51tD7HpBsPsl1rB75Tzs6mRcl+HtbaHlv2Xk2/7D7vmTYqTrOtQ2veIBKEPyxUWw1evm/VMsf5KS39FVYLkv8HIV69Bfc0ftbFIt/UreIBrPOlc4jdnTQoVdaCPp1E9t18carbEO5SP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RnCZ3b0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RnCZ3b0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6E7C4CEE9;
	Tue, 27 May 2025 17:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365737;
	bh=GffCcDeN5XBFRCFFkCDhX5xgQ5fj+/HVT2n/YAKI2oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RnCZ3b0UxgsQKHQsY5DoHLjkxPp/nknm+ouATqDageL0gpkcF5rJGkEAdg3j5UKFI
	 gtZ0YD5LpQ0Woh8fap1RbE5j1kaBau6j2+56dfQ1HIYLDQxOLv3DtCjBoigj9WoOiE
	 uwf+FHXAGEk8Xdt7usiw3Y1R+W/n3xsIGnYYfOpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 445/626] tools: ynl-gen: dont output external constants
Date: Tue, 27 May 2025 18:25:38 +0200
Message-ID: <20250527162503.080983297@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 7e8b24e24ac46038e48c9a042e7d9b31855cbca5 ]

A definition with a "header" property is an "external" definition
for C code, as in it is defined already in another C header file.
Other languages will need the exact value but C codegen should
not recreate it. So don't output those definitions in the uAPI
header.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Link: https://patch.msgid.link/20250203215510.1288728-1-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index 463f1394ab971..c78f1c1bca75c 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -2417,6 +2417,9 @@ def render_uapi(family, cw):
 
     defines = []
     for const in family['definitions']:
+        if const.get('header'):
+            continue
+
         if const['type'] != 'const':
             cw.writes_defines(defines)
             defines = []
-- 
2.39.5



