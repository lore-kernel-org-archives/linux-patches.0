Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0832B25745C;
	Tue, 25 Mar 2025 12:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905601; cv=none; b=CQKbshK5OJJO7eAuYO+ms7K6/jt5AvQmPRmoZsk0FvJxYTfPM74ehnkgDSJRz2cowi82prTFmEswgzk1rg3SUBftDkLkqg98Vzof294vtxCrp8DK7nUkiAllfSSK63O3/lzLkTsoSDFSzRQ7lX21UpBR4CFowWpneiQJ6xO2PIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905601; c=relaxed/simple;
	bh=wE0KJxUwC3zwHTCFP3z0N3OEFrnefdIDdaNeBXE79Jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WFfHjbUVonc8qVOgUyPphcabOEtsrs+ApMd8a3sr7T+q6SC9G2/b+7WgnNg6vFUrWRVJqpdIJSvBNxH09OplR09lrgNUe3HjBIK1/5lOrao6w60CAIT1o2JiOBEQ4uyAfkZEWHkjQnwrA4STMjX9nOGE0/8LBHKAM4TlhktMRr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EIZ9usro; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EIZ9usro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5BFC4CEF0;
	Tue, 25 Mar 2025 12:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905600;
	bh=wE0KJxUwC3zwHTCFP3z0N3OEFrnefdIDdaNeBXE79Jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EIZ9usroru24SdTNvj8i/09553VwoEyPzazHUS+YHxqjjDa6VRkV28Ji8OCjYg/Fi
	 s2/ZVthVgPAxSyw4tPEwNSBIR8pflLgkt/LiCkNSP+Yw5CDAVvrCoK/rIJetSvhk3l
	 G7uu5fakzsNjWWS2OD1+LGW/7l34DCB7o8CieT7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 062/198] nvme: only allow entering LIVE from CONNECTING state
Date: Tue, 25 Mar 2025 08:20:24 -0400
Message-ID: <20250325122158.269593477@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit d2fe192348f93fe3a0cb1e33e4aba58e646397f4 ]

The fabric transports and also the PCI transport are not entering the
LIVE state from NEW or RESETTING. This makes the state machine more
restrictive and allows to catch not supported state transitions, e.g.
directly switching from RESETTING to LIVE.

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index ba76cd3b5f852..6a636fe6506b4 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -501,8 +501,6 @@ bool nvme_change_ctrl_state(struct nvme_ctrl *ctrl,
 	switch (new_state) {
 	case NVME_CTRL_LIVE:
 		switch (old_state) {
-		case NVME_CTRL_NEW:
-		case NVME_CTRL_RESETTING:
 		case NVME_CTRL_CONNECTING:
 			changed = true;
 			fallthrough;
-- 
2.39.5



