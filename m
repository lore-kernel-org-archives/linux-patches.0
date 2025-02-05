Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC533155333;
	Wed,  5 Feb 2025 15:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767714; cv=none; b=foMnh0w9DtpED968TpD7wB4XetpGSPPuDbPyoSrAFpGMImxAVIwWdmwE1yilcaRbKlvH0Ux7397iON+Vvvegu/w2qTpGnmJY3M4k86UKDe2zUWg+h3UjFUG4Tz75yljRXQBXm5G8FeoutXpxHwnZcx4oFfV5ocOe/k/OZsH32Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767714; c=relaxed/simple;
	bh=Xu9fD2xGeVpzXLYKeN/GZIIPRDazchiO6a1zwZoLDVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jsSTf19tMuFlnQMgXY6vGTcWSOyv61hri/2omQlkpB2mcSeRK+tNMAewBHytFj/LMRyn3opyMZ+AhTQmVV1EQDncWisWtzXpGIOGpr/xeg4zFPKPDlEbm0pDvMBd/C7fcrKCU1J7Vli8fjTOv/p/+QvW2WyBA+GdDGVmjujnK8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HSULKR/G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HSULKR/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7754C4CED1;
	Wed,  5 Feb 2025 15:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767712;
	bh=Xu9fD2xGeVpzXLYKeN/GZIIPRDazchiO6a1zwZoLDVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HSULKR/GznIVp6rDVFZMQlvaZmu+PoTHfooK8r0V2+dhTeWfq/GTeG/ClijHVYX0j
	 O2BqZriw8rJcs6iMA7JekSPBKjqaMGmHVb4O09UvX9navKc7FbKTH71z7vZe6J0NLV
	 hyzPS+ifYdjRG/Kg06/QgmNePbBGCIYs8H9D9kyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	syzbot+ffba8e636870dac0e0c0@syzkaller.appspotmail.com,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 442/623] media: rc: iguanair: handle timeouts
Date: Wed,  5 Feb 2025 14:43:04 +0100
Message-ID: <20250205134513.128487846@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit b98d5000c50544f14bacb248c34e5219fbe81287 ]

In case of a timeout the IO must be cancelled or
the next IO using the URB will fail and/or overwrite
an operational URB.

The automatic bisection fails because it arrives
at a commit that correctly lets the test case run
without an error.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Fixes: e99a7cfe93fd ("[media] iguanair: reuse existing urb callback for command responses")
Reported-by: syzbot+ffba8e636870dac0e0c0@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/66f5cc9a.050a0220.46d20.0004.GAE@google.com/
Tested-by: syzbot+ffba8e636870dac0e0c0@syzkaller.appspotmail.com
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/iguanair.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index 276bf3c8a8cb4..8af94246e5916 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -194,8 +194,10 @@ static int iguanair_send(struct iguanair *ir, unsigned size)
 	if (rc)
 		return rc;
 
-	if (wait_for_completion_timeout(&ir->completion, TIMEOUT) == 0)
+	if (wait_for_completion_timeout(&ir->completion, TIMEOUT) == 0) {
+		usb_kill_urb(ir->urb_out);
 		return -ETIMEDOUT;
+	}
 
 	return rc;
 }
-- 
2.39.5



