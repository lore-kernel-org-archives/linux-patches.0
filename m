Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409A3200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:05:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3638C433C8;
	Fri, 21 Jul 2023 19:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966324;
	bh=zgeZaabOBHeeKJZ8I+zbXMnyCKgbbvA+KKhcsY53BS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t20+VEy7enZGL2F3yoa0dxox0c8ToHznn743ZmoygKpFozufnhGjKNm5RfvOq/siQ
	 UHyhyZAusvfgh2nUps3HhGEXkSTg3XFhFSqBQlX3otKWh/6dl4W7e9AcSwlfxAm5i+
	 Ga6IsMQkZy4QISevmDTzsxK29Z9Sw+jbu1kRQLNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 303/532] mfd: stmfx: Nullify stmfx->vdd in case of error
Date: Fri, 21 Jul 2023 18:03:27 +0200
Message-ID: <20230721160630.839060205@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Amelie Delaunay <amelie.delaunay@foss.st.com>

[ Upstream commit 7c81582c0bccb4757186176f0ee12834597066ad ]

Nullify stmfx->vdd in case devm_regulator_get_optional() returns an error.
And simplify code by returning an error only if return code is not -ENODEV,
which means there is no vdd regulator and it is not an issue.

Fixes: d75846ed08e6 ("mfd: stmfx: Fix dev_err_probe() call in stmfx_chip_init()")
Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Link: https://lore.kernel.org/r/20230609092804.793100-2-amelie.delaunay@foss.st.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/stmfx.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/stmfx.c b/drivers/mfd/stmfx.c
index 6e1629beb8094..9852f49c3f881 100644
--- a/drivers/mfd/stmfx.c
+++ b/drivers/mfd/stmfx.c
@@ -330,9 +330,8 @@ static int stmfx_chip_init(struct i2c_client *client)
 	stmfx->vdd = devm_regulator_get_optional(&client->dev, "vdd");
 	ret = PTR_ERR_OR_ZERO(stmfx->vdd);
 	if (ret) {
-		if (ret == -ENODEV)
-			stmfx->vdd = NULL;
-		else
+		stmfx->vdd = NULL;
+		if (ret != -ENODEV)
 			return dev_err_probe(&client->dev, ret, "Failed to get VDD regulator\n");
 	}
 
-- 
2.39.2



