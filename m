Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A298E1CB518;
	Wed, 19 Feb 2025 08:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954312; cv=none; b=RcLf8rd5wIafPY9RQgguqTNxUqCpRhkkTr+SVTQbwnTJ1lbbSYJ+zGmNzMEHeIjG8tXXLJSqy7ZNpD2NlZpVhlYJz7A575Iu1NYbi17MkpIh+veMoT0LDIVVu445O6Q2Kry+u2Ephs20KUfC/1bM8fpH3oPNprREWj8OO2YDowc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954312; c=relaxed/simple;
	bh=BuFXdB4hVDnnrFhyrCzpgsej4gdL3VuBFncTCfIVR1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UTSBPnuC1n60X/OKeSUUqVPr4/+nwTewNynOT1CJpKFVSzIPZtBJHUyJ18j4vzRcgIbfVnLtzTJ1ryDJc9Z8bltIYn51yNv+r/2aiUhflCdi4w/MDh4qN0M3GUEvEOjRQK8J5k8xGTUBULR8/NGA7FNnokqD1oyoVw6gCBeSapc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J3Vf9cOC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J3Vf9cOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D2EC4CED1;
	Wed, 19 Feb 2025 08:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954312;
	bh=BuFXdB4hVDnnrFhyrCzpgsej4gdL3VuBFncTCfIVR1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J3Vf9cOCymqkUhowSrC+d+F6yXv1fvIo2R8vEE9a24SaOiY/zg6xzrHX44wAid0CI
	 u4aeqr9JreqF7V6BZId0W+hJ2dYUn3iPGlHU3Ol5PXWNJ/oij2AAcRJdLVITfAxBTv
	 o0pzJZhzF/Ik7fy6QscNTq8JS1QVGGqCwqV+hle8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.13 164/274] rtnetlink: fix netns leak with rtnl_setlink()
Date: Wed, 19 Feb 2025 09:26:58 +0100
Message-ID: <20250219082616.013057713@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit 1438f5d07b9a7afb15e1d0e26df04a6fd4e56a3c upstream.

A call to rtnl_nets_destroy() is needed to release references taken on
netns put in rtnl_nets.

CC: stable@vger.kernel.org
Fixes: 636af13f213b ("rtnetlink: Register rtnl_dellink() and rtnl_setlink() with RTNL_FLAG_DOIT_PERNET_WIP.")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250205221037.2474426-1-nicolas.dichtel@6wind.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/rtnetlink.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3423,6 +3423,7 @@ static int rtnl_setlink(struct sk_buff *
 		err = -ENODEV;
 
 	rtnl_nets_unlock(&rtnl_nets);
+	rtnl_nets_destroy(&rtnl_nets);
 errout:
 	return err;
 }


