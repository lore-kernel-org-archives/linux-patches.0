Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF1219883C;
	Thu,  6 Jun 2024 14:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683036; cv=none; b=S4LiYJ1wvjMEHLsJniX7KTupc2+jc8c5vqit4zBC/rZQKTBY0jFQJIHAiKh0GrfTIkMQ3JkZygD2vXXzJPz22I7VdT8tMA1pEzkRfGJIjmPCtEd5VXywt6Y2HE2AOzLuvZBIMIw4jPZNFIguNB1Q30AXeh+dpgTM+m5cx4z0/C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683036; c=relaxed/simple;
	bh=X44lgXNLlXe0zzlP4UUoUz/EkCD18w4nv8nYRP89zMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZfG3GmS6r4e5adG6Fv//dba/ZIP7uAGxJ9mr34wQyCCcN7yeWqaBYnaPoYdX73YJqdnywUlZTI4wwD+2ayT4mMFEuCn3/GdA0pnhqohH3bJPJgXIIHfkHVXUj02fQ7GBbgTZ5fS9hPSuLpZeehwvMnhJKqo6lFt3qyi0XGsAW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aSVyYXhc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aSVyYXhc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D97C4AF50;
	Thu,  6 Jun 2024 14:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683035;
	bh=X44lgXNLlXe0zzlP4UUoUz/EkCD18w4nv8nYRP89zMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aSVyYXhcmFcga/6MHc7zIsuD1aUD6lj+s4miXnwS5YfilTLMHOMfMLBBpL6CtMU9q
	 N8PaCLHyiloSSH7FyvtS8w3TR3P3rIiioUx2B/lopyfXPjp28henKKSE8uPk64z4yr
	 2mzg0RDt71RhJvfCychQzktvzrJdge+wkp2r4l04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 263/374] i3c: master: svc: change ENXIO to EAGAIN when IBI occurs during start frame
Date: Thu,  6 Jun 2024 16:04:02 +0200
Message-ID: <20240606131700.704236389@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 7f3d633b460be5553a65a247def5426d16805e72 ]

svc_i3c_master_xfer() returns error ENXIO if an In-Band Interrupt (IBI)
occurs when the host starts the frame.

Change error code to EAGAIN to inform the client driver that this
situation has occurred and to try again sometime later.

Fixes: 5e5e3c92e748 ("i3c: master: svc: fix wrong data return when IBI happen during start frame")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/r/20240506164009.21375-2-Frank.Li@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index 5ee4db68988e2..a2298ab460a37 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -1080,7 +1080,7 @@ static int svc_i3c_master_xfer(struct svc_i3c_master *master,
 	 * and yield the above events handler.
 	 */
 	if (SVC_I3C_MSTATUS_IBIWON(reg)) {
-		ret = -ENXIO;
+		ret = -EAGAIN;
 		*actual_len = 0;
 		goto emit_stop;
 	}
-- 
2.43.0



