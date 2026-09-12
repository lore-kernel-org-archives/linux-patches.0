Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3307B33F59A;
	Sat, 12 Sep 2026 13:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219924; cv=none; b=sw4mZfqXQ45P/MbCNLSMaKP4CyDdle0IcT4GRBbwS6xAHQxjQGVDPu0EAozWaFhJH+MmEFQmTRVq/aZrGyY22BuisuL0u4cZz/NfMtDcoI3V14xRwsKzWXcAQya10onn8iZ3wIfLDw1I6s9MQolF/bY1udtTdM56Pwadt55APpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219924; c=relaxed/simple;
	bh=rbtExssbqUml6IDKeumVN3duFeJbmOMsjmy4NZ4cMJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8Qg9Na48Zc0oaYHIVMEJ0IPHP9PPa9+FAY5jteiQX6aawKZipzpyqmzPKbBFmuo368CufPHB5TCWLPjN/iaXepJjIFxYqflD69ariPdYKwYcrM5P4qZIUzg+YLdu/C4hTu8PfGLNDWGANdROlyKodmSE+ekWujVbH8Fri74Oug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=clH18P12; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="clH18P12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945391F000FF;
	Sat, 12 Sep 2026 13:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219922;
	bh=/jd3PTbys0ZGuJQdRMJDNej2DbplMHq2afmz3l06FR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=clH18P12c1Xas0NMsiQKppP081jw0r9aoMfNHvqronoBES9dwrYLPhsbdnk2RwJm8
	 qy+2Bl48vGUvQA1N3kweJz5b1gEe7g3XEsu9d1mWpLRPa1MVmDt28ZwQb/Uf1RDMsr
	 Y0GmocGixrEfd4VpNX9RH05F+JlKdWWI4uE54RAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao-Qun Huang <alvinhuang0603@gmail.com>
Subject: [PATCH 6.6 0029/1424] staging: greybus: hid: fix SET_REPORT return value
Date: Sat, 12 Sep 2026 08:41:01 +0200
Message-ID: <20260912065607.959079444@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Hao-Qun Huang <alvinhuang0603@gmail.com>

commit 6d45195a9626d8aaaaed212c55638829a9c624a3 upstream.

__gb_hid_output_raw_report() stores the result of gb_hid_set_report()
in ret and even adjusts it to account for the report ID byte, but then
always returns 0.

This hides Greybus transport errors from HID_REQ_SET_REPORT callers,
and makes hidraw report zero bytes written to user space on success,
although hid_hw_raw_request() is expected to return the number of
bytes transferred or a negative errno. The sibling GET_REPORT path,
__gb_hid_get_raw_report(), already follows this convention.

Return ret like the other HID transport drivers do.

Fixes: 96eab779e198 ("greybus: hid: add HID class driver")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5
Signed-off-by: Hao-Qun Huang <alvinhuang0603@gmail.com>
Link: https://patch.msgid.link/20260704081613.434445-1-alvinhuang0603@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/greybus/hid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/greybus/hid.c
+++ b/drivers/staging/greybus/hid.c
@@ -256,7 +256,7 @@ static int __gb_hid_output_raw_report(st
 	if (report_id && ret >= 0)
 		ret++; /* add report_id to the number of transferred bytes */
 
-	return 0;
+	return ret;
 }
 
 static int gb_hid_raw_request(struct hid_device *hid, unsigned char reportnum,


