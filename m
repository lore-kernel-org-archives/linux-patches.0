Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811C1190068;
	Tue, 10 Sep 2024 10:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965084; cv=none; b=svr+yF26RFnZn4jSqu8DQYczOu8ZguS+17TFjiMKrBNIPaEQq3UmTiaMmVAhAiP1RvSFQq9skfixbKH6yzGxq4SSDRUZec1dCLIpMFs+dqJyYhtdxKY5axjY6/cWgjdkHJkCqIa3VL1CqHflWXPhdEoDg8Xi35XTDpmFxGadrkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965084; c=relaxed/simple;
	bh=AtjDi/hY+bhjNNPnfyZowrO4XzVA2F66BdMSIWlDbfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JSmj9nxQUGhS/JUZuf3E4EMQtEmFAtQiIcDDwnunWFLT2t/K7LEERDyqabL5VugbxDUqTeJG5WC3koi/Ey5wxnM7m7tf5/EckdfUb2G4kGtTSXnfMG2kGjWQvPqY+v//XK1NvVWTQjBY/SoquBjqAUvich1TW9Z5a/BJbud3sO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mnAMfp26; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mnAMfp26"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08841C4CEC3;
	Tue, 10 Sep 2024 10:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965084;
	bh=AtjDi/hY+bhjNNPnfyZowrO4XzVA2F66BdMSIWlDbfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mnAMfp26zFA6wlYbvcZvw+URWu631ZThEC4RgXfplbJbQ4qtpFpL9u9jcNBmWkS9H
	 v1WiuvRh0J/h1Sz1bvb3jDjWy8Nd4uIO6eGxeHu4nP8V4LmofXAswk0rlxDzRyin9r
	 KMtftvXFTo5QrySYrwJ1zRP9zDQ2qW35KXZBqEv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 132/186] um: line: always fill *error_out in setup_one_line()
Date: Tue, 10 Sep 2024 11:33:47 +0200
Message-ID: <20240910092600.023327682@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 37e96ba0f5fb..d2beb4a497a2 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -378,6 +378,7 @@ int setup_one_line(struct line *lines, int n, char *init,
 			parse_chan_pair(NULL, line, n, opts, error_out);
 			err = 0;
 		}
+		*error_out = "configured as 'none'";
 	} else {
 		char *new = kstrdup(init, GFP_KERNEL);
 		if (!new) {
@@ -401,6 +402,7 @@ int setup_one_line(struct line *lines, int n, char *init,
 			}
 		}
 		if (err) {
+			*error_out = "failed to parse channel pair";
 			line->init_str = NULL;
 			line->valid = 0;
 			kfree(new);
-- 
2.43.0



