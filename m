Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39A718C02E;
	Tue, 10 Sep 2024 10:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963679; cv=none; b=MNVMe9tBhJRhnnfA4tBEQGlN4GbPsttuLb75hoqKPTUOTSc0Qk08sm1QAgowbptFt+BGvIllofVEMhUF9s/joAcgf1BakHSY/JT7SjckTC1pJXpoocM/KMKxZ+381pKTCshF5hK03mvURc4QS4Dkvill4YsZAZ3QEdqkvnd1MCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963679; c=relaxed/simple;
	bh=wBDfKJSckhyagS/GxguDaznPZRghFk3T2Cal6X3mFB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tdI63sBE1VK0cDQ2kKXmKkZ73ZxYnDJMwTlx+hbeAYH9ZMQYrE2mcSXnUY6J75YHNr0s8yS7kMqedBqmPRmK4OEnGrXVP+d+R1qL7fkgHmosbaE4NxprDrVahqzTk4rQuk/zw5vOYe3n0g8OCyiWCtnz5xUF2C3N7U4cZJHe6Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oputM9Bi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oputM9Bi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57CC0C4CEC3;
	Tue, 10 Sep 2024 10:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963679;
	bh=wBDfKJSckhyagS/GxguDaznPZRghFk3T2Cal6X3mFB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oputM9BiwGZFtIg8LObRjDi8I1cO8asad1hvFQxmHvmE6I3Shgy6dSxLCxLe6Flr2
	 OwoEoBHFNPniS+rDy+0gjk+XO9dfOA70C9vO1Bw+xD2ILW1f6gGahRAyVuv2ot7373
	 mKIWvAxI8UrmLGn8cF+IttaLcbgE5RVOcUSTYIMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 139/214] um: line: always fill *error_out in setup_one_line()
Date: Tue, 10 Sep 2024 11:32:41 +0200
Message-ID: <20240910092604.428858712@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 95ad6b190d1d..6b4faca401ea 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -383,6 +383,7 @@ int setup_one_line(struct line *lines, int n, char *init,
 			parse_chan_pair(NULL, line, n, opts, error_out);
 			err = 0;
 		}
+		*error_out = "configured as 'none'";
 	} else {
 		char *new = kstrdup(init, GFP_KERNEL);
 		if (!new) {
@@ -406,6 +407,7 @@ int setup_one_line(struct line *lines, int n, char *init,
 			}
 		}
 		if (err) {
+			*error_out = "failed to parse channel pair";
 			line->init_str = NULL;
 			line->valid = 0;
 			kfree(new);
-- 
2.43.0



