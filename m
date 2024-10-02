Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726131D1E67;
	Wed,  2 Oct 2024 14:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878190; cv=none; b=Qmn7CRpjf4RJiMcJE6gq0ewcRCezARSSgNTbngLN56LbuLWil714tARG0V/9Ej7bzsAA1AJhr1gFkRdtuggiETF4GNq1JGnmnn4w/nYpTHEmU7a5Vw6Nb7H/oddYpRGsi7Q7GPeuzdhuY6fCgjpSh0P778cXs5RbDVOmmVP5/1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878190; c=relaxed/simple;
	bh=jcl/c2YOF86B9+2qy8X/mIZtgu3qnY17vTto0/K13xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGwG4juS0kKdKp+3a8LdsGPWh5Kz/o1iu92kuIZCztNfbDoGVzZXI6D/j8IJPVoYsWHTAWJFQKOfhxnGX8n2hlQbJQF+acnWVI6Ww1B3zgETVArmC7H8WZVcQ7Yd+pG9encAgqFI0rJGWjK2idgntgWxBuL6dgZyt+7itHCfMCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=spGG+4wx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="spGG+4wx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEE1C4CECD;
	Wed,  2 Oct 2024 14:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878190;
	bh=jcl/c2YOF86B9+2qy8X/mIZtgu3qnY17vTto0/K13xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=spGG+4wxfYEA/2Xa6q1FCd0+OOxyN8CdZSnMiRgWofhrPvgX/VtMJH5J0B24juMi9
	 SSaWxswFjHjdobfdPHaCFaOz3OgtFE8WckQ0sVc1yvx3DdQmMzCJ2CbbpTA4l6QsHu
	 wLwPY0sHRgCVnuEhGZPiKT7/gWcuff7qOwkI2qOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 303/634] perf dwarf-aux: Handle bitfield members from pointer access
Date: Wed,  2 Oct 2024 14:56:43 +0200
Message-ID: <20241002125823.068862773@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit a11b4222bb579dcf9646f3c4ecd2212ae762a2c8 ]

The __die_find_member_offset_cb() missed to handle bitfield members
which don't have DW_AT_data_member_location.  Like in adding member
types in __add_member_cb() it should fallback to check the bit offset
when it resolves the member type for an offset.

Fixes: 437683a9941891c1 ("perf dwarf-aux: Handle type transfer for memory access")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240821232628.353177-2-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dwarf-aux.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index 0e7d2060740df..1b0e59f4d8e93 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -1977,8 +1977,15 @@ static int __die_find_member_offset_cb(Dwarf_Die *die_mem, void *arg)
 		return DIE_FIND_CB_SIBLING;
 
 	/* Unions might not have location */
-	if (die_get_data_member_location(die_mem, &loc) < 0)
-		loc = 0;
+	if (die_get_data_member_location(die_mem, &loc) < 0) {
+		Dwarf_Attribute attr;
+
+		if (dwarf_attr_integrate(die_mem, DW_AT_data_bit_offset, &attr) &&
+		    dwarf_formudata(&attr, &loc) == 0)
+			loc /= 8;
+		else
+			loc = 0;
+	}
 
 	if (offset == loc)
 		return DIE_FIND_CB_END;
-- 
2.43.0



