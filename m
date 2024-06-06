Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B6C1B1424;
	Thu,  6 Jun 2024 14:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683375; cv=none; b=nvkXWJRWx9aTFhSCQ6EaXt9Azxp8zLwpJd+uYUWJf0B4y7QmxqdG/cLHhA1GNH3sNGnqwWyerucAO9hpUcLMYZPGTX/f3ZLYKgBQCLBcvJPTv1yxOIPOAaQaIhcqiUMKyZX8I+UdS2x81U1YtWBD5ddvsAXBM/bqDzp67pl+yq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683375; c=relaxed/simple;
	bh=IZmf2473CHfEAMOpj5FugVaedyt22dfRaHe6qq9r0gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FgiFrMEq/qdcER2wH/I43sm134hFwDfPN+iOPFDeBPeTg0bZ2Z5qQBb0+sv3s/MpQe1LaAszEZhxsSHCeQCPeAGgDFMnqntfvDPXA9EX6O3zVjkFnG3XI6vAp7vS7k+/t4xC4wbZaQAM1nw37LptYlCk4H4dup+XFg15DNWp6lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zb3Lq8YA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zb3Lq8YA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0AE3C32781;
	Thu,  6 Jun 2024 14:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683374;
	bh=IZmf2473CHfEAMOpj5FugVaedyt22dfRaHe6qq9r0gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zb3Lq8YA7at5OzKDQ74yBnTqiWFQEl9yuYc7OMyE9xs87UeE5QmeLNFNrnAhfGcoj
	 WlrGzcVfZ1Lyc7rhDZES4jq0Ac0i/gsDGpw0mszR9MfyD7KB6b6IdikYt/8UEvW9dC
	 I6ZuUKBUbkhE+zEaVHo2rNom/KQwauxLpxZya8YA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huai-Yuan Liu <qq810974084@gmail.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 316/744] drm/arm/malidp: fix a possible null pointer dereference
Date: Thu,  6 Jun 2024 15:59:48 +0200
Message-ID: <20240606131742.561429880@linuxfoundation.org>
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

From: Huai-Yuan Liu <qq810974084@gmail.com>

[ Upstream commit a1f95aede6285dba6dd036d907196f35ae3a11ea ]

In malidp_mw_connector_reset, new memory is allocated with kzalloc, but
no check is performed. In order to prevent null pointer dereferencing,
ensure that mw_state is checked before calling
__drm_atomic_helper_connector_reset.

Fixes: 8cbc5caf36ef ("drm: mali-dp: Add writeback connector")
Signed-off-by: Huai-Yuan Liu <qq810974084@gmail.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240407063053.5481-1-qq810974084@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/arm/malidp_mw.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/arm/malidp_mw.c b/drivers/gpu/drm/arm/malidp_mw.c
index 626709bec6f5f..2577f0cef8fcd 100644
--- a/drivers/gpu/drm/arm/malidp_mw.c
+++ b/drivers/gpu/drm/arm/malidp_mw.c
@@ -72,7 +72,10 @@ static void malidp_mw_connector_reset(struct drm_connector *connector)
 		__drm_atomic_helper_connector_destroy_state(connector->state);
 
 	kfree(connector->state);
-	__drm_atomic_helper_connector_reset(connector, &mw_state->base);
+	connector->state = NULL;
+
+	if (mw_state)
+		__drm_atomic_helper_connector_reset(connector, &mw_state->base);
 }
 
 static enum drm_connector_status
-- 
2.43.0



