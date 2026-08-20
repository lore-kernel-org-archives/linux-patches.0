Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85E947CC97;
	Thu, 20 Aug 2026 16:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244281; cv=none; b=VFcjo8hsZh0hjfMwfjS7pa9eflTfrUeVau5NiVw+1Ackgt7gcFysgBlxEogNHpN196n/jlHMOeBxj1T1OTMHCyLuAs/w3PbMTo4N+1kydvXjbYstgA1UglLFnT//5qxr1Vyw/t/ZM+puWEaAM6DTphMYZlUfyn0xtoo/dtVC4dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244281; c=relaxed/simple;
	bh=P4JpehKUdF7XLKYE+6DQz2heTGX9Orfo/sPk30HZO3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D1Y+IIxtPQwAUkKkdRfKTTwfE9OiIVV+M/8o48ZJqN9RFIUL1ve3HLlvjTafyKDtwsYFaq0Zl3YMr8iHDmjwO05YJnftCzR11/NkKyrB1SEeNzo3amTQ7mTuZihLgf939NQRr8KsHaKKUFQHgOvi5cL7rJhyWZwxrvWj+/aIsjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JJgYmlBW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JJgYmlBW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403291F000E9;
	Thu, 20 Aug 2026 16:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244279;
	bh=NTXcnsu3iS+Q40pn5q10Yl6pck8hXYLWwB3LB3VeQTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JJgYmlBWbf2PZ4GlD4v1DqJkpQPF7hPt9c7R8dZ6JnQSs072O0Bs4WoGNYfxBwCNT
	 3iwwbcy7cfhpu78M1RZOKy2a631dgKx32NtPeIfoMWpX6e5fuL3ephq6f/avOh30in
	 hR4QvUiITj8cAr5ISkWKqrTD4OuZZxLxBj/p4yRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/235] Input: ims-pcu - fix race condition in reset_device sysfs callback
Date: Thu, 20 Aug 2026 16:55:50 +0200
Message-ID: <20260820145219.911130868@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 411b8c4b274737c3bf08e1e025801161603cfffc ]

The ims_pcu_reset_device() sysfs callback calls ims_pcu_execute_command()
without acquiring pcu->cmd_mutex. This can lead to data races and
corruption of the shared command buffer if triggered concurrently with
other commands.

Acquire pcu->cmd_mutex before calling ims_pcu_execute_command().

Fixes: 628329d52474 ("Input: add IMS Passenger Control Unit driver")
Cc: stable@vger.kernel.org
Reported-by: Sashiko bot <sashiko-bot@kernel.org>
Assisted-by: Gemini:gemini-3.1-pro
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/ims-pcu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -1193,6 +1193,8 @@ static ssize_t ims_pcu_reset_device(stru
 
 	dev_info(pcu->dev, "Attempting to reset device\n");
 
+	guard(mutex)(&pcu->cmd_mutex);
+
 	error = ims_pcu_execute_command(pcu, PCU_RESET, &reset_byte, 1);
 	if (error) {
 		dev_info(pcu->dev,


