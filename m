Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA674EB863;
	Tue, 13 Oct 2026 12:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893176; cv=none; b=bGDy+y0il4VFDUdKnESmF53rjkoSTwWgm9c1ahGMBjJCcjv9zXlwH9wUvJ3OLmchvprPlafMANSh7OyEzvhT8RMZOO9p6plWUzKTVMK6yJGrYNIa0k2SQOefqUBdO4HvEI3T+ODWWMW3EuUiOd6WGfWheVFtBaWWc/2ZzyeNOPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893176; c=relaxed/simple;
	bh=oJGli94tvxDzW1rEvHf9udzf9klXA5Ey6hZQq9A0D/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ERZJUBuWpC0JoKp/UTdyKJBTsUxtCRVUh30dvNUs4dJn5LVTyj8uQw7JB8sxN16J+Q4ucUIk2DB4qos4k7N9CMP3TSN8aJInM5t1ru0N9W8xdvTQ1Z1blJWNLU+fu17oHib/ceSCLuTIXjcRySN2XW8Io0t7rilfDuG67rR1CkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QpPnjK13; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QpPnjK13"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B001F000FF;
	Tue, 13 Oct 2026 12:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893174;
	bh=cGuoZYL7wq9P3S/W+eAj5qbuukYFPs3Y6mH+sidmE4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QpPnjK13sCUVIcIXhMkEajzEpvdcefX1d8Qn1yjbKI1kfDgqELuWDVWYVC0uhLy1M
	 5OzS9Z0o1G/O+v/ET+j2H8ZyTv4exQYet8fTt1p7voTZOu3bAPvtk49k3ngp43l5It
	 zuoR0ODac5hqaypGEJnon2DWtg366eNqGH1c/JyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sajal Gupta <sajal2005gupta@gmail.com>,
	Ruben Wauters <rubenru09@aol.com>
Subject: [PATCH 6.18 111/621] drm/gud: dont keep a connector without a CRTC as connector_state
Date: Tue, 13 Oct 2026 13:31:46 +0200
Message-ID: <20261013112923.485660979@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


