Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE763BD63B;
	Sat, 17 Oct 2026 17:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257324; cv=none; b=sXskFXkqRW133tOD5kGi5fFAEYESiMdZvv67YTivXDJh3/fTEZ3IMuf4pPlFuqtD7aVO5QhfIk3i1tNN39v5HaUyMCe2GImotMSIej1Bp76maBr+zuCF1TfcPpxSYrTcGBpPBGG1enYCd/YeKy8tTl16DvN0Enyb4yLK5hZPGIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257324; c=relaxed/simple;
	bh=3RqrwaElAeI/Zfhk9nRu8MXKOB2vY2L4BTnDf3bi8rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CNbczaDgGN5F44+PRy7XZyRF+IPUf8HVwYhKFXWG++gIl65wra2f9kyi9k7Islk4Z/I3/rf/XtUJDPZAisX1IDJwre9KSmDteZAJeeS2pAR1woYJ0vesJPHF9nrKo0UQEPj7SUi+Pyn2GmsJ6NXC5Ger4rxw1icls0N6C7UqP3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nljt8XI+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nljt8XI+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45DA41F000C4;
	Sat, 17 Oct 2026 17:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257323;
	bh=F8AE3bGeW4vAhY5FmKXpC1X+tudZR/Ug3ZemJGs/GRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nljt8XI+g07sFPRUdgSZJFzi5UeTR0e7tlwv7qassYSZQl/yL8KvNDZ4iNa0259B+
	 rPE1t5pFMALedOHf7SeSrX6DK3OMA5OAenpEfo/2LIRJxrsaFh6idFjI83Ls4NrrFD
	 2jqSMDq0KW4MxYQhZUEnUtBJO87vnPLg+Z/ba1Bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sajal Gupta <sajal2005gupta@gmail.com>,
	Ruben Wauters <rubenru09@aol.com>
Subject: [PATCH 6.6 0521/1674] drm/gud: dont keep a connector without a CRTC as connector_state
Date: Sat, 17 Oct 2026 17:46:33 +0200
Message-ID: <20261017160444.478282528@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sajal Gupta <sajal2005gupta@gmail.com>

commit 71ec70ea26e399eb8371fe9d2d5bf5dab09570fb upstream.

If the 'for_each_new_connector_in_state()' loop finishes without
hitting the break, connector_state is left pointing at the last
connector visited, which has no CRTC, instead of
staying NULL.

That skips the "if (!connector_state)" fallback below the loop, which
looks up the active connector when the state contains none. The
function then carries on with a connector that is not driven.

Fix by resetting connector_state to NULL for each connector visited that
has no CRTC, so that it is NULL when none was found and the fallback runs.

Fixes: 40e1a70b4aed ("drm: Add GUD USB Display driver")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260902123254.36987-1-sajal2005gupta@gmail.com?part=1
Signed-off-by: Sajal Gupta <sajal2005gupta@gmail.com>
Acked-by: Ruben Wauters <rubenru09@aol.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Ruben Wauters <rubenru09@aol.com>
Link: https://patch.msgid.link/20260922084026.15481-1-sajal2005gupta@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/gud/gud_pipe.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/gud/gud_pipe.c
+++ b/drivers/gpu/drm/gud/gud_pipe.c
@@ -480,6 +480,7 @@ int gud_pipe_check(struct drm_simple_dis
 	for_each_new_connector_in_state(state, connector, connector_state, i) {
 		if (connector_state->crtc)
 			break;
+		connector_state = NULL;
 	}
 
 	/*


