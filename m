Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644784C3CC;
	Mon,  8 Jan 2024 15:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mRteBajX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB34C433CB;
	Mon,  8 Jan 2024 15:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726597;
	bh=qx9SM/VZjVHhI97D50uUpQLSDto2roBKMI86wBGK0ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mRteBajXTyUpq8vW69xIworemvXXni9yeah84HaSoSH74P8o0smhJ0kv8xdvYv1mb
	 lwQok+oblFa3NKTcQVvRUxKWtP363zR2IY48p9MpW5m+xINIvcKGTWri5nmRFj+Yu6
	 mdaxN6hJYe3yZyCwmALZC0ttvIju+64jbP//0UTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Boyd <swboyd@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/124] drm/bridge: parade-ps8640: Never store more than msg->size bytes in AUX xfer
Date: Mon,  8 Jan 2024 16:07:24 +0100
Message-ID: <20240108150603.816004448@linuxfoundation.org>
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

[ Upstream commit 3164c8a70073d43629b4e11e083d3d2798f7750f ]

While testing, I happened to notice a random crash that looked like:

  Kernel panic - not syncing: stack-protector:
  Kernel stack is corrupted in: drm_dp_dpcd_probe+0x120/0x120

Analysis of drm_dp_dpcd_probe() shows that we pass in a 1-byte buffer
(allocated on the stack) to the aux->transfer() function. Presumably
if the aux->transfer() writes more than one byte to this buffer then
we're in a bad shape.

Dropping into kgdb, I noticed that "aux->transfer" pointed at
ps8640_aux_transfer().

Reading through ps8640_aux_transfer(), I can see that there are cases
where it could write more bytes to msg->buffer than were specified by
msg->size. This could happen if the hardware reported back something
bogus to us. Let's fix this so we never write more than msg->size
bytes. We'll still read all the bytes from the hardware just in case
the hardware requires it since the aux transfer data comes through an
auto-incrementing register.

NOTE: I have no actual way to reproduce this issue but it seems likely
this is what was happening in the crash I looked at.

Fixes: 13afcdd7277e ("drm/bridge: parade-ps8640: Add support for AUX channel")
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20231214123752.v3.1.I9d1afcaad76a3e2c0ca046dc4adbc2b632c22eda@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/parade-ps8640.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/parade-ps8640.c b/drivers/gpu/drm/bridge/parade-ps8640.c
index 8161b1a1a4b12..d264b80d909de 100644
--- a/drivers/gpu/drm/bridge/parade-ps8640.c
+++ b/drivers/gpu/drm/bridge/parade-ps8640.c
@@ -330,11 +330,12 @@ static ssize_t ps8640_aux_transfer_msg(struct drm_dp_aux *aux,
 				return ret;
 			}
 
-			buf[i] = data;
+			if (i < msg->size)
+				buf[i] = data;
 		}
 	}
 
-	return len;
+	return min(len, msg->size);
 }
 
 static ssize_t ps8640_aux_transfer(struct drm_dp_aux *aux,
-- 
2.43.0



