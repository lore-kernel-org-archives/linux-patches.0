Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAABD350A3D;
	Fri, 21 Nov 2025 13:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733529; cv=none; b=tsUWV/JnqVqncljTKRxp6fXpAT/DcZG0fxokJ/jFQwIYldqNvO7ZxikWjE4e2XU36PKUeZbgnXqKMnVLjmOsTVAOnL9CYmWtX+yElNXSn8PmvUsqXn8cPDFyPYxDhfHAMtlkbW2H0p2XnAUNvw6eqyCcKqjYsd/pQGkt7GUlwao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733529; c=relaxed/simple;
	bh=YIw2+djKyzll9vTxc747enP37y7gVkZe57RyJqw0Af4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPiFycBXpnP6kfPIF+aVUUsBkb75Qy6M5YbNH0uqjrdvoeZQGCLpvde75SX8UEtpc7Y3zAmYoXCuU6KwGw1lqh8xP1g3yKqHA1oc+zIf8b2APHZqcnZkl6Pgd6CZtG3HE3zIuL+HnIotxO7QTuF1SJRb7r0iYNIuE6wQcrtadmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kyH+QJje; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kyH+QJje"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC0DAC4CEF1;
	Fri, 21 Nov 2025 13:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733529;
	bh=YIw2+djKyzll9vTxc747enP37y7gVkZe57RyJqw0Af4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kyH+QJjeGFIl+urFaaF6sdevlbrTBW+lFYEISnaJQWyuCjDO/vkLCT95nLESltcZB
	 0gsX5wv8CMOVfpqoM1ccE9u80sNY5rQtQWEu/lJydnaBdZlT03E8SLnNL4V87LMvug
	 Fo3bkeVGDMO96kWNrrI0onpad1Rpmy61EUyUm2SA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"jingxian.li" <jingxian.li@shopee.com>
Subject: [PATCH 6.6 492/529] Revert "perf dso: Add missed dso__put to dso__load_kcore"
Date: Fri, 21 Nov 2025 14:13:11 +0100
Message-ID: <20251121130248.512582668@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "jingxian.li" <jingxian.li@shopee.com>

This reverts commit e5de9ea7796e79f3cd082624f788cc3442bff2a8.

The patch introduced `map__zput(new_node->map)` in the kcore load
path, causing a segmentation fault when running `perf c2c report`.

The issue arises because `maps__merge_in` directly modifies and
inserts the caller's `new_map`, causing it to be freed prematurely
while still referenced by kmaps.

Later branchs (6.12, 6.15, 6.16) are not affected because they use
a different merge approach with a lazily sorted array, which avoids
modifying the original `new_map`.

Fixes: e5de9ea7796e ("perf dso: Add missed dso__put to dso__load_kcore")

Signed-off-by: jingxian.li <jingxian.li@shopee.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/symbol.c |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1366,7 +1366,6 @@ static int dso__load_kcore(struct dso *d
 				goto out_err;
 			}
 		}
-		map__zput(new_node->map);
 		free(new_node);
 	}
 


