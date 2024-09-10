Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C46118A6DF;
	Tue, 10 Sep 2024 09:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961104; cv=none; b=PBd8XTBEWxJAM6bUssfs7kM9RZM3bax1bSbCoCyHghvBy2A1afpMQl4TL7roo+Pld6nTSfI7/qIcsxnpudFHxCFh3w1no0MK3DnI3vArPOPpg1QKZHSjGCH+hDnxsPqO3N1jk74U5Da2zRIJXKc/aJWVwwWsPbB1oZHOU63MwAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961104; c=relaxed/simple;
	bh=ayagaVSj5UK0MBHnHzJs8YntauAHHG5cfWbvOdOM0kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lPd6/ZrjcOAKcP1ZF3QDqtshc1Qjxcm4DHeX+FegnJ0x2TL4FwMmCyF6xQt/Q0pSFGu6/C4crdQZHYd5a68LX3dmtduTb5ayvAZcG53Smfnut1ukafRxVBEB1/loI2BwAs6mv5BTBvQBMeqBOskuXnRjj+LyFEk+xOFriD0A+9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OCzEGcRf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OCzEGcRf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC04C4CEC3;
	Tue, 10 Sep 2024 09:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961103;
	bh=ayagaVSj5UK0MBHnHzJs8YntauAHHG5cfWbvOdOM0kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OCzEGcRfWgf9POXMTlK4YdH4aoq3EarjyklHNIYaDVIRyvNUqVng40489+un5dTr2
	 oVf0AplHMCSKZUlH+srQwh0XDtvgkpxjQqNw0B0DcGt/ZJMxHU+JFjUDZjt6QXCqU5
	 jagZbTw76G0FRNksDEI4YXBiSQvuDrO/APx+MrhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 54/96] um: line: always fill *error_out in setup_one_line()
Date: Tue, 10 Sep 2024 11:31:56 +0200
Message-ID: <20240910092543.899673655@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 824ac4a5edd3f7494ab1996826c4f47f8ef0f63d ]

The pointer isn't initialized by callers, but I have
encountered cases where it's still printed; initialize
it in all possible cases in setup_one_line().

Link: https://patch.msgid.link/20240703172235.ad863568b55f.Iaa1eba4db8265d7715ba71d5f6bb8c7ff63d27e9@changeid
Acked-By: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/line.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index 71e26488dfde..b5c3bc0e6bce 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -391,6 +391,7 @@ int setup_one_line(struct line *lines, int n, char *init,
 			parse_chan_pair(NULL, line, n, opts, error_out);
 			err = 0;
 		}
+		*error_out = "configured as 'none'";
 	} else {
 		char *new = kstrdup(init, GFP_KERNEL);
 		if (!new) {
@@ -414,6 +415,7 @@ int setup_one_line(struct line *lines, int n, char *init,
 			}
 		}
 		if (err) {
+			*error_out = "failed to parse channel pair";
 			line->init_str = NULL;
 			line->valid = 0;
 			kfree(new);
-- 
2.43.0



