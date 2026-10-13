Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CE64F052C;
	Tue, 13 Oct 2026 11:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892376; cv=none; b=ND9WuX7yj7vgKTV++C+XlUfPFvcNwcglf9uqyG/nohYlRi+Vwd/hbSJ/PnDNIFxn6p4IlKY/lHdJOb/ogs/2eS1IwpDkPNM3WrIizy7InsHP9yV9aBN1oVsrO8dD3B/dxpNC++ksA4FUMvvHVo0P4ML+VUc0sklrXbLCIK8E0r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892376; c=relaxed/simple;
	bh=7i7tFUejqCk4Kc0tx2OwuI/xoxf9/U+VpGaD5xGRKJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dksisHz+NY1GlqzvagwGCqoauiDIXpod0DYqbHQUagla7ezk5RnQMkSqrYV8pCyO/e+6jrGFmnH8f1omdbf0ugL+2TUonmUOI5OKW9k09S5m0LOeMlrCYS5efGwqvalHJOXm1GU3sz5kukELgvwQvrKu5AN6SkJD5AQ+lpGQes8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B6CzmMhS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B6CzmMhS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090C51F00893;
	Tue, 13 Oct 2026 11:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892374;
	bh=fcAN6A/DRPT/rZk0oDTehaUYpBpVblW3EWVxAaAgNlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B6CzmMhSzyigA0jkpdtbGgxve+EKb8bVuxwEQjYBX9P8Opwv7W6Y7DNXdoUkVEwGx
	 Vu7wNwKASLsy0pHqFuzYcriMblrO3JsZUBHr2Z1bIW6GPEXnmmh6AR4q8+XOiC5laK
	 9shAY6pQhQ1WMZOwCRBDnCSe9QPa7eqGsKDAetLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sajal Gupta <sajal2005gupta@gmail.com>,
	Ruben Wauters <rubenru09@aol.com>
Subject: [PATCH 7.2 125/281] drm/gud: dont keep a connector without a CRTC as connector_state
Date: Tue, 13 Oct 2026 13:37:21 +0200
Message-ID: <20261013112858.184107508@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -507,6 +507,7 @@ int gud_plane_atomic_check(struct drm_pl
 	for_each_new_connector_in_state(state, connector, connector_state, i) {
 		if (connector_state->crtc)
 			break;
+		connector_state = NULL;
 	}
 
 	/*


