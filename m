Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7711B011D;
	Thu,  6 Jun 2024 14:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683361; cv=none; b=nk57grwjzaUBUX8H71q7P7LuoJRcBAo/kT5yc5p98ObuIvf/ue1GfIuQT0ijB3GFZCAauJkRSwKcfa4PiWc6Wn2LblUTnjgJZCdTjUps9dwndWipAgA7W7KgMUYKmTgoSK7e9v+867+gKwyZ+rFeP4CqD3w/E6x2V4+aacaX7hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683361; c=relaxed/simple;
	bh=fPNUiZKlUZsz+kMbS3jl9Z0jmVt8YNWVn8uX96VrAZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHlxxF2ucG/ZmRwq7av/wsMZRjjGXIwgoPNZ2DOfDtnDz/RwY7FAkV1G2iQET6n8lgjQMKlSJxrngjgrDONsoN7Nfh3+8QKPKv9cUawTYOFcYR71pVKDTuOYsZvyptlDmCuwe5V+0T71lI7+JDzLyag7qMCH6zeHJldxiRptObY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s80N0zt3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s80N0zt3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57FFFC32782;
	Thu,  6 Jun 2024 14:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683361;
	bh=fPNUiZKlUZsz+kMbS3jl9Z0jmVt8YNWVn8uX96VrAZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s80N0zt3FafDZS7ifcaluKaoB1J3833s2DgnFtqVWqlVXESJBoxK+5TdHxzWrn9Kc
	 9H7QIsLdLvfmK6i+1XkKamhgXJFh98QYzACYWvDPMHz5deMM7rxQj91yv8knGhCUA4
	 had17hfhWjTJXrqHkFsRBzQXBY0iUBI0JqIh5XTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Burakov <a.burakov@rosalinux.ru>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 303/744] media: ngene: Add dvb_ca_en50221_init return value check
Date: Thu,  6 Jun 2024 15:59:35 +0200
Message-ID: <20240606131742.102451996@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Aleksandr Burakov <a.burakov@rosalinux.ru>

[ Upstream commit 9bb1fd7eddcab2d28cfc11eb20f1029154dac718 ]

The return value of dvb_ca_en50221_init() is not checked here that may
cause undefined behavior in case of nonzero value return.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 25aee3debe04 ("[media] Rename media/dvb as media/pci")
Signed-off-by: Aleksandr Burakov <a.burakov@rosalinux.ru>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/ngene/ngene-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/ngene/ngene-core.c b/drivers/media/pci/ngene/ngene-core.c
index 7481f553f9595..24ec576dc3bff 100644
--- a/drivers/media/pci/ngene/ngene-core.c
+++ b/drivers/media/pci/ngene/ngene-core.c
@@ -1488,7 +1488,9 @@ static int init_channel(struct ngene_channel *chan)
 	}
 
 	if (dev->ci.en && (io & NGENE_IO_TSOUT)) {
-		dvb_ca_en50221_init(adapter, dev->ci.en, 0, 1);
+		ret = dvb_ca_en50221_init(adapter, dev->ci.en, 0, 1);
+		if (ret != 0)
+			goto err;
 		set_transfer(chan, 1);
 		chan->dev->channel[2].DataFormatFlags = DF_SWAP32;
 		set_transfer(&chan->dev->channel[2], 1);
-- 
2.43.0



