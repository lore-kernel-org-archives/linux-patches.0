Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AED10A1F;
	Sat,  3 Feb 2024 04:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933692; cv=none; b=I8YsRaVlOEtWHQHcVblcQwyR6jGBGfosie4EO65RhxjTgkP50VgW7vv/LL9D0ysNz//IQQtCIW14ltfB6DaTjOrKE2KFg+KrmKOPHdgwf2NMrgxmjrRAMR3Mw7V71PCQ5iUdOltVJ4fr/GdUhEK9pPYNWR8lrI+roPwWn2d5sG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933692; c=relaxed/simple;
	bh=l9SxfXL9FLXUepiP8wu+4aIIiKrlckMpg8pZlb/uGVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVWNmrGe7/MplNEFiSUKA0x6y6DwnH53RWziGOSabP65b16ulJGmIU85ybDIt/8ltAk8rn2CHzb42H4eS+IRfxMU+DpwZPx0h0pmGOM75EmWX/j1XfAsAhgdC0GiQz8QgaUZE9OG5uF7OMZFK1kFxXmwAY62Sd2Dwtq5K+pkCzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IMsIkQeN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IMsIkQeN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D3BC433F1;
	Sat,  3 Feb 2024 04:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933691;
	bh=l9SxfXL9FLXUepiP8wu+4aIIiKrlckMpg8pZlb/uGVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IMsIkQeNMJFaXecCTSUWv3zXbrXIjC6gNh7BNGG3XHurLxclqTsQHsQ+hd0/YsAIB
	 nKrvLUt0IIDAbXYWADVTd2yDWGDZltK1OYqCgiuvIhS0Re9HY+Xwblp2VjfRb7waD7
	 jppMY9dReV/Q0PftMaA7JlN8GgHQNM0LhbNJplEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 264/322] scsi: isci: Fix an error code problem in isci_io_request_build()
Date: Fri,  2 Feb 2024 20:06:01 -0800
Message-ID: <20240203035407.662562967@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 658365c6b0857e6a306436e315a8633937e3af42 ]

Clang static complains that Value stored to 'status' is never read. Return
'status' rather than 'SCI_SUCCESS'.

Fixes: f1f52e75939b ("isci: uplevel request infrastructure")
Signed-off-by: Su Hui <suhui@nfschina.com>
Link: https://lore.kernel.org/r/20240112041926.3924315-1-suhui@nfschina.com
Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/isci/request.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index a7b3243b471d..7162a5029b37 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -3390,7 +3390,7 @@ static enum sci_status isci_io_request_build(struct isci_host *ihost,
 		return SCI_FAILURE;
 	}
 
-	return SCI_SUCCESS;
+	return status;
 }
 
 static struct isci_request *isci_request_from_tag(struct isci_host *ihost, u16 tag)
-- 
2.43.0



