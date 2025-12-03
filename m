Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280CD34888F;
	Wed,  3 Dec 2025 16:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778348; cv=none; b=Bl0k4cf1ePqOOGwb/34CWwgbqwbm0WbEEJpLU5QwYXplEUeiEWimTtFlr6/KSrMHyZ7KJBIZOL1B5r6dvtzcGzJseuuxcFBjLCbX/GPXzfcYp+vlq1MI7F6kay3yewRDy3J5gplGF8UQssC7aHSvICUhNZlQoOR6xU16PBDbDJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778348; c=relaxed/simple;
	bh=hnozSIcLkd3TVczrvPlcou7V3DyCOUG8VFXqbDbN/bI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ahHipwskhul8dObybYmJCzWx5k5Nx8Ea3BycYCqk2mHQGlRlYwgNo5ezgQTv9UkU6VS8a3XfXypHoVnz1LLJG9+k+laLUgVxmfncKYm7RUpHgV1zxhFuP4/5U6KDpXLVnqWEf1Bb0Ro1v46c8EtXRjyG7ccs2lks2q5V5xRfO+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EqVx6xld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EqVx6xld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31955C4CEF5;
	Wed,  3 Dec 2025 16:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778347;
	bh=hnozSIcLkd3TVczrvPlcou7V3DyCOUG8VFXqbDbN/bI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EqVx6xldSu8Kh3jy4rzfrp8tw7hR1sn8UnE75vIqs+za86C4giED73s5Lc8wqeltq
	 l9kzT7Zvmya11Qv8ZjGq+N4W/kjUzcIJdGsD5lcpeaPbWItqQdbfMMQ0NbXP8PBUn/
	 DQCu5eZGSckGKejEygRn6Nm3u+u6AvOmmomarMLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 319/392] pmdomain: imx: Fix reference count leak in imx_gpc_remove
Date: Wed,  3 Dec 2025 16:27:49 +0100
Message-ID: <20251203152425.898628365@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit bbde14682eba21d86f5f3d6fe2d371b1f97f1e61 ]

of_get_child_by_name() returns a node pointer with refcount incremented, we
should use of_node_put() on it when not needed anymore. Add the missing
of_node_put() to avoid refcount leak.

Fixes: 721cabf6c660 ("soc: imx: move PGC handling to a new GPC driver")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
[ drivers/pmdomain/imx/gpc.c -> drivers/soc/imx/gpc.c ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/imx/gpc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/soc/imx/gpc.c
+++ b/drivers/soc/imx/gpc.c
@@ -540,6 +540,8 @@ static int imx_gpc_remove(struct platfor
 			return ret;
 	}
 
+	of_node_put(pgc_node);
+
 	return 0;
 }
 


