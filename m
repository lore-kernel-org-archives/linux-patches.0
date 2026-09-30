Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5579B50B8BA;
	Wed, 30 Sep 2026 18:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793132; cv=none; b=rELfm+wfUp31E0Dp3d/1f0pT+l8p73K7UQYH0i/CItCxtJ3gFVMrkST7B5Gfpwc2zefw/JT1S+djdNgF68m8Up9MwrJFgCTHXSRY6OOYJtJB2WpA5QMyv/URKXQhcEFYgIfsNlRyW0cmH/WWTPNZFqf/R6/IBbDODQbMeVtM62Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793132; c=relaxed/simple;
	bh=P5uz9C75QM3o6gglGoMRSQM0W4Meurph00lsXe+N1xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ppYIcgPV2l4Bb244JkmFT+QE6d3nAARZ0plXQFCrfVSttHGhPXCSEK4vN71PafMe6+MNrnIutY+v2l7WWRbS/B6a6kK29JSnSuzZhqlZH3pP86tLH4wVhfCwt6Q9cnp+c/btM91l45JDtMgCWn6kfmqKZ7ZnrhfkIEr7UwBP2rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZygwxK9K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZygwxK9K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736CC1F000FF;
	Wed, 30 Sep 2026 18:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793130;
	bh=wr/Q8l8nFxODRG14tLU8NJxxfPJF5Rwj+L/1VMl9I6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZygwxK9Ka/hScZIfZkvDjYWwQcCLni9tzV99b5r58sPzYoQYoM3WwHQOWT57cVRgX
	 MFkHPiFk22FQuuDl4/dHoU5nlaWyEBxgojzVi1jcaug/FBI26eD1oVbgWGa+D451df
	 WOe/3hNWjBSVIR6JAp2cZrudtKdf8JU83T3Wpz0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaithanya Lagisetty <nagachaithanya9911@gmail.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 146/395] selftests: nci: Fix uninitialized family ID on missing attribute
Date: Wed, 30 Sep 2026 17:26:48 +0200
Message-ID: <20260930152343.810157263@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Chaithanya Lagisetty <nagachaithanya9911@gmail.com>

[ Upstream commit eda518d2cdb6074a0bcdfa06af291616bcb5c421 ]

get_family_id() walks the generic netlink CTRL_CMD_GETFAMILY reply
looking for the CTRL_ATTR_FAMILY_ID attribute and returns the parsed
value in the local variable "id". If the reply does not carry that
attribute, the parsing loop never assigns "id" and the function returns
an indeterminate stack value, which the caller stores in self->fid and
uses for subsequent netlink requests.

Initialize "id" to 0 so a missing attribute yields a deterministic
(invalid) family ID instead of a garbage value.

Fixes: f595cf1242f3 ("selftests: Add nci suite")
Signed-off-by: Chaithanya Lagisetty <nagachaithanya9911@gmail.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Link: https://patch.msgid.link/20260901070618.3299012-1-nagachaithanya9911@gmail.com
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/nci/nci_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/nci/nci_dev.c b/tools/testing/selftests/nci/nci_dev.c
index 8e09623d96a76..cc0732d439e02 100644
--- a/tools/testing/selftests/nci/nci_dev.c
+++ b/tools/testing/selftests/nci/nci_dev.c
@@ -182,7 +182,7 @@ static int get_family_id(int sd, __u32 pid, __u32 *event_group)
 	} ans;
 	struct nlattr *na;
 	int resp_len;
-	__u16 id;
+	__u16 id = 0;
 	int len;
 	int rc;
 
-- 
2.53.0



