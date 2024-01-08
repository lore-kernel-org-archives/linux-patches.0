Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5164C624;
	Mon,  8 Jan 2024 15:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m8w72E7H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E11C433C8;
	Mon,  8 Jan 2024 15:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726628;
	bh=ZUZa31sLzmyoYL51E06bXyoZeS7pNPeu8Ab1J7RpTxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m8w72E7HWCBIhFD/gL6W/z7Ywezv7Jz9be5vfVoom+JuevMXBgwtHLSLsSWrnO5JM
	 CRIspH98GRjy9kMuW5XXUSmuJ01Bq+4xroeBnFVxhiDdmc/J8w9X3mwVS8vVTm7Lr3
	 quG29qNROrTbgouk+oI+IGVdqNil0Jkow+MKp65k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Boyd <swboyd@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/124] drm/bridge: ps8640: Fix size mismatch warning w/ len
Date: Mon,  8 Jan 2024 16:07:26 +0100
Message-ID: <20240108150603.890039978@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 35ba6bd582cf926a082296b7e9a876ec81136cb1 ]

After commit 26195af57798 ("drm/bridge: ps8640: Drop the ability of
ps8640 to fetch the EDID"), I got an error compiling:

  error: comparison of distinct pointer types
  ('typeof (len) *' (aka 'unsigned int *') and
   'typeof (msg->size) *' (aka 'unsigned long *'))
  [-Werror,-Wcompare-distinct-pointer-types]

Fix it by declaring the `len` as size_t.

The above error only shows up on downstream kernels without commit
d03eba99f5bf ("minmax: allow min()/max()/clamp() if the arguments have
the same signedness."), but since commit 26195af57798 ("drm/bridge:
ps8640: Drop the ability of ps8640 to fetch the EDID") is a "Fix" that
will likely be backported it seems nice to make it easy. ...plus it's
more correct to declare `len` as size_t anyway.

Fixes: 26195af57798 ("drm/bridge: ps8640: Drop the ability of ps8640 to fetch the EDID")
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20231218090454.1.I5c6eb80b2f746439c4b58efab788e00701d08759@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/parade-ps8640.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/parade-ps8640.c b/drivers/gpu/drm/bridge/parade-ps8640.c
index d264b80d909de..541e4f5afc4c8 100644
--- a/drivers/gpu/drm/bridge/parade-ps8640.c
+++ b/drivers/gpu/drm/bridge/parade-ps8640.c
@@ -210,7 +210,7 @@ static ssize_t ps8640_aux_transfer_msg(struct drm_dp_aux *aux,
 	struct ps8640 *ps_bridge = aux_to_ps8640(aux);
 	struct regmap *map = ps_bridge->regmap[PAGE0_DP_CNTL];
 	struct device *dev = &ps_bridge->page[PAGE0_DP_CNTL]->dev;
-	unsigned int len = msg->size;
+	size_t len = msg->size;
 	unsigned int data;
 	unsigned int base;
 	int ret;
-- 
2.43.0



