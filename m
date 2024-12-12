Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DED215764;
	Thu, 12 Dec 2024 17:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024451; cv=none; b=pymsAOzjd6NRu6Wif2JMXoJp7DqcSsv+UwIGpt2DFuY/cEsS8yNRzkMs8YlP25Rlx/TEfRdxQB0RobqeBgyQOBFZ6ma22+rVt9UQ24IJk5jE8miA9FSSjw8kQNmXhMUcfPLfhy3gBiHLr6Wr9vvJTRhOqlr+mqpnrLb1BDLXj9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024451; c=relaxed/simple;
	bh=0u4PesDOO1OqmywZ8Jl5s7nLAEu9Sl9zfofZZk0XTy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FWrNqzXumOw4exo+mdnCU6xIVNW9WgQltMpwcEsm4HYq74zbOcUvYW2tt5E/o9vLOZ6GmU2djnPndKNaX/Li060HE71LGiF+11jxTBApl09qFga8rW4d5Kva/4xfFcLoHn/6Fa/KWzzeB1WF3+sf+6zizmjgtHfr4pwaTdg/Xao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u/eFG3dl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u/eFG3dl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EBB9C4CED0;
	Thu, 12 Dec 2024 17:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024451;
	bh=0u4PesDOO1OqmywZ8Jl5s7nLAEu9Sl9zfofZZk0XTy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u/eFG3dlH2G4LEhzWOkyZQKlVhgdYhJj4YJX8PJA3P7R8DTs7UzpHVMnXMMCcSZfR
	 DcMM3csuzbNlhtIO6K0K0jMhGJ8+HYaYlLPcxKPC6l54D41XasV0AJRFZdMc0KtnQ0
	 loMZe15jO+UBcmU7tFrTrGt+dvxxIMwj+5wBpx7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Zenla <alex@edera.dev>,
	Alexander Merritt <alexander@edera.dev>,
	Ariadne Conill <ariadne@ariadne.space>,
	Juergen Gross <jgross@suse.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 300/459] 9p/xen: fix init sequence
Date: Thu, 12 Dec 2024 16:00:38 +0100
Message-ID: <20241212144305.492630908@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

From: Alex Zenla <alex@edera.dev>

[ Upstream commit 7ef3ae82a6ebbf4750967d1ce43bcdb7e44ff74b ]

Large amount of mount hangs observed during hotplugging of 9pfs devices. The
9pfs Xen driver attempts to initialize itself more than once, causing the
frontend and backend to disagree: the backend listens on a channel that the
frontend does not send on, resulting in stalled processing.

Only allow initialization of 9p frontend once.

Fixes: c15fe55d14b3b ("9p/xen: fix connection sequence")
Signed-off-by: Alex Zenla <alex@edera.dev>
Signed-off-by: Alexander Merritt <alexander@edera.dev>
Signed-off-by: Ariadne Conill <ariadne@ariadne.space>
Reviewed-by: Juergen Gross <jgross@suse.com>
Message-ID: <20241119211633.38321-1-alexander@edera.dev>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_xen.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index da056170849bf..dc8702024c555 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -487,6 +487,7 @@ static int xen_9pfs_front_init(struct xenbus_device *dev)
 		goto error;
 	}
 
+	xenbus_switch_state(dev, XenbusStateInitialised);
 	return 0;
 
  error_xenbus:
@@ -534,8 +535,10 @@ static void xen_9pfs_front_changed(struct xenbus_device *dev,
 		break;
 
 	case XenbusStateInitWait:
-		if (!xen_9pfs_front_init(dev))
-			xenbus_switch_state(dev, XenbusStateInitialised);
+		if (dev->state != XenbusStateInitialising)
+			break;
+
+		xen_9pfs_front_init(dev);
 		break;
 
 	case XenbusStateConnected:
-- 
2.43.0



