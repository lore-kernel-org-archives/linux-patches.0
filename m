Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8BD5218B1;
	Wed, 30 Sep 2026 17:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790603; cv=none; b=p+lURzXNmsCwpYnIK1RsgFGtf73YMGOsxXs6V2EgyxYM7JfrAnOjeVFYcDDCH8N1eT5Rnaa7IDWGnAx+0YPI5SwBmA37wD1V+23mVvyDtkaL/5By/uGu35pz6Uhu539L9SU3VL6xv6TOiv3V9QjqrYkg4Nq3POSP3V/DLtF0u78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790603; c=relaxed/simple;
	bh=t7NP8qhIogBfJtjnSGzF/Vxs0K77J1/duSh1whJNuzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqy5GQJGln+Mflp2f2y4zJjoOIKPb5i7cDpdNZbDFZoW+q++WaCzFFnsG4+lpA+bZJhPGvF1A343Va4iITfE1GpPNyzlfDXp7FsSNdzFQibN+rGPuOuvoYBFAZWRrQ8EijR3LW6zT0sinRaR7s3NKwiQ9R4dGfhtDzVYRVImk0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sjg6hEOt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sjg6hEOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6391F000FF;
	Wed, 30 Sep 2026 17:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790602;
	bh=xh+EwvOz+bS5sXpa9WVmoTjRgf3hm03HfGNUE18cmn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sjg6hEOtzbjvH03o62GbgTRCI7iYOgOZX49upHxahcifsU0Z2Z1lUV4eMhhFg4zgI
	 qwksjHaX9HnprfNWbJfbbYM06DzhNnjwJCaM8/4/27ZKR6fISBtP6MIsP5lLwgLc1z
	 SXj4lA+c0hfx/tyMiXJoZr0woA88rDWOnPFP+aDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 010/752] soundwire: validate DT compatible before parsing it
Date: Wed, 30 Sep 2026 17:18:00 +0200
Message-ID: <20260930152358.369051719@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 45c7bda7b7440183850012153988e40b300f40d0 ]

`sdw_of_find_slaves()` fetches raw `"compatible"` bytes with
`of_get_property()` and then immediately parses them with
`sscanf("sdw%01x%04hx%04hx%02hhx", ...)`.

Live-tree OF properties are stored as raw bytes plus a separate length;
they are not globally guaranteed to be NUL-terminated. Validate the
first compatible string before parsing it.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260403183504.4-soundwire-compatible-pengpeng@iscas.ac.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/slave.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soundwire/slave.c b/drivers/soundwire/slave.c
index a5a9118612de2..2a6563951b22a 100644
--- a/drivers/soundwire/slave.c
+++ b/drivers/soundwire/slave.c
@@ -216,8 +216,8 @@ int sdw_of_find_slaves(struct sdw_bus *bus)
 		struct sdw_slave_id id;
 		const __be32 *addr;
 
-		compat = of_get_property(node, "compatible", NULL);
-		if (!compat)
+		ret = of_property_read_string(node, "compatible", &compat);
+		if (ret)
 			continue;
 
 		ret = sscanf(compat, "sdw%01x%04hx%04hx%02hhx", &sdw_version,
-- 
2.53.0



