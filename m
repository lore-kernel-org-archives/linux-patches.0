Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73821DAC9F;
	Tue,  3 Dec 2024 15:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241067; cv=none; b=dyyMo/5UtfE+uxVYvgMD206r8TwvasaA04f3Z4PqBrQb6yl6Nw3zfILWKjnSOa9VprMbaNZ9eHg0B9tSh2r+5JseDxEFfRCiJIX+4LwkFVMhoAtI2TlURswsh3ypyU2tBTVKG4MugL6cxMfsTjBUzWpOVobi9vcoYk0TXd+jhio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241067; c=relaxed/simple;
	bh=ZAPbPNhvl6vIcOiCBBdy/vAaqcCyJBdNy6epXJFntrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IP6W5nY42KAnXB+bWKWYM7+K7P/Rp3aAoB7UvVIBTqyDqGIDhMF2BfEX5/j/G/XvCbV3tiaw7A4maeQHC1rKCXxrDuWlEZmIQR4LQXnKFfYdv40Q9FWcxymdYDUXyHFTy1VK3ANWDCNkIYbrj8NBJL0U3NOh6Nl4OG7igRCuDR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TGTO6TjI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TGTO6TjI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46214C4CECF;
	Tue,  3 Dec 2024 15:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241067;
	bh=ZAPbPNhvl6vIcOiCBBdy/vAaqcCyJBdNy6epXJFntrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TGTO6TjIWLA5MEpl75m/vov2PKLH089Uc1atB1LfMmVkoERaHdk/xgKdOIKoMWVgl
	 lH6euO7k3VuwngUEbJhQMPheSimPUp0fJyUjUSxKns3ALOkcjxmpjSAm4EqKix10Ri
	 c/M+2EDhE+A37/CXknqJVEQZFMSy4841MEWRUlZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 316/826] selftests: net: really check for bg process completion
Date: Tue,  3 Dec 2024 15:40:43 +0100
Message-ID: <20241203144756.089327146@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 52ed077aa6336dbef83a2d6d21c52d1706fb7f16 ]

A recent refactor transformed the check for process completion
in a true statement, due to a typo.

As a result, the relevant test-case is unable to catch the
regression it was supposed to detect.

Restore the correct condition.

Fixes: 691bb4e49c98 ("selftests: net: avoid just another constant wait")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/0e6f213811f8e93a235307e683af8225cc6277ae.1730828007.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/pmtu.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index 569bce8b6383e..6c651c880fe83 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -2056,7 +2056,7 @@ check_running() {
 	pid=${1}
 	cmd=${2}
 
-	[ "$(cat /proc/${pid}/cmdline 2>/dev/null | tr -d '\0')" = "{cmd}" ]
+	[ "$(cat /proc/${pid}/cmdline 2>/dev/null | tr -d '\0')" = "${cmd}" ]
 }
 
 test_cleanup_vxlanX_exception() {
-- 
2.43.0



